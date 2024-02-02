//
//  CollectionViewController.swift
//  Compositional-Layout
//
//  Created by Nikolai Maksimov on 02.02.2024.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    
    // объявляем наш источник данных, который будет использовать различимый источник данных
    // проверка: Идентификатор раздела и Идентификатор элемента должны быть хешируемыми объектами
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

private extension CollectionViewController {
    
    func commonInit() {
        configureCollectionView()

    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView.backgroundColor = .systemYellow
        view.addSubview(collectionView)
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        // создаем и настраиваем элемент (item)
        // элемент занимает 25% ширины группы
        // элемент занимает 100% высоты группы
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // создаём и настраиваем группу
        // группа занимает 100% ширины раздела
        // высота группы составляет 25% ширины раздела
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.25))
        //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        // настраиваем раздел (section)
        let section = NSCollectionLayoutSection(group: group)
        
        // настраиваем макет (layout)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    

}
