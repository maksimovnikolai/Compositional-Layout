//
//  NestedGroupViewController.swift
//  Nested-Groups-and-Orthogonal-Scrolling
//
//  Created by Nikolai Maksimov on 03.02.2024.
//

import UIKit

enum SectionKind: Int, CaseIterable {
    case first
    case second
    case third
    
    var itemCount: Int {
        switch self {
        case .first:
            return 2
        default:
            return 1
        }
    }
    
    var nestedGroupHeight: NSCollectionLayoutDimension {
        switch self {
            
        case .first:
            return .fractionalWidth(0.9)
        default:
            return .fractionalWidth(0.45)
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .first:
            return "First Section"
        case .second:
            return "Second Section"
        case .third:
            return "Third Section"
        }
    }
}


final class NestedGroupViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Int>
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        navigationController?.title = "Nested Groups and Orthogonal Scrolling"
    }
}

// MARK: - ConfigureCollectionView
extension NestedGroupViewController {
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        view.addSubview(collectionView)
    }
}

// MARK: - CreateLayout
extension NestedGroupViewController {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                return nil
            }
            
            // item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
            item.contentInsets = .init(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            // group
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                        heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, repeatingSubitem: item, count: sectionKind.itemCount)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                         heightDimension: sectionKind.nestedGroupHeight)
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [innerGroup])
            
            // section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            // заголовок раздела
            // можно установить размеры, используя: .fractional, Absolute, .estimated
            // Шаги по добавлению заголовка в раздел
            // 1. определяем размер и добавляем в раздел
            // 2. зарегистрировать дополнительное представление
            // 3. исключить из очереди дополнительное представление
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
}
