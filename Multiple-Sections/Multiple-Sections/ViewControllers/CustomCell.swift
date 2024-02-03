//
//  CustomCell.swift
//  Multiple-Sections
//
//  Created by Nikolai Maksimov on 03.02.2024.
//

import UIKit

final class CustomCell: UICollectionViewCell {
    
    static let identifier = "CustomCell"
    
    let label: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraints() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
