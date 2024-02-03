//
//  MultipleSectionViewController.swift
//  Multiple-Sections
//
//  Created by Nikolai Maksimov on 03.02.2024.
//

import UIKit

final class MultipleSectionViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case grid
        case single
        
        var columnCount: Int {
            switch self {
            case .grid:
                return 4
            case .single:
                return 1
            }
        }
    }
    
    private var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int> // оба аргумента должны соответствовать Hashable
    
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.backgroundColor = .green
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // sectionIndex - индекс раздела (секции)
            // layoutEnvironment - см. док-цию
            
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            let columns = sectionType.columnCount
            
            // что такое контейнер элемента? => группа
            // создаем макет: элемент -> группа -> раздел -> макет
            
            let itemWidth = columns == 1 ?
            NSCollectionLayoutDimension.fractionalWidth(1.0) :
            NSCollectionLayoutDimension.fractionalWidth(0.25)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth,
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            // что такое групповой контейнер? => раздел (section)
            let groupHeight = columns == 1 ?
            NSCollectionLayoutDimension.absolute(200) :
            NSCollectionLayoutDimension.fractionalWidth(0.25)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           repeatingSubitem: item,
                                                           count: columns) // 1 или 4
            
            let section = NSCollectionLayoutSection(group: group)
            
            // настройка заголовка
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header] // footer
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
                fatalError("could not dequeue a CustomCell")
            }
            
            cell.label.text = "\(item)"
            
            if indexPath.section == 0 { // first section
                cell.backgroundColor = .systemOrange
                cell.layer.cornerRadius = 12
            } else {
                cell.backgroundColor = .systemCyan
                cell.layer.cornerRadius = 10
            }
            return cell
        })
        
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "headerView",
                for: indexPath) as? HeaderView else {
                fatalError("could not dequeue a headerView")
            }
            headerView.textLabel.text = "\(Section.allCases[indexPath.section])".capitalized
            return headerView
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.grid, .single])
        snapshot.appendItems(Array(1...12), toSection: .grid)
        snapshot.appendItems(Array(13...20), toSection: .single)
        dataSource.apply(snapshot)
    }
}

