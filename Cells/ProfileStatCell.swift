//
//  ProfileStatCell.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

// part of the original plan, currently not being used.
class ProfileStatCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseID          = "ProfileStatCell"
    
    let statLabel               = UILabel()
    let typeLabel               = UILabel()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    func configure() {
        backgroundColor         = .secondarySystemBackground
        layer.cornerRadius      = 10
        configureLabels()
    }
    
    func configureLabels() {
        statLabel.font          = UIFont.systemFont(ofSize: 38, weight: .bold)
        statLabel.textColor     = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        statLabel.textAlignment = .center
        
        addSubview(statLabel)
        
        typeLabel.font          = UIFont.preferredFont(forTextStyle: .body)
        typeLabel.textAlignment = .center
        addSubview(typeLabel)
        
        statLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat    = 8
        
        NSLayoutConstraint.activate([
            statLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: statLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    
    func set(stat: String, type: ProfileStatType) {
        statLabel.text          = stat
        typeLabel.text          = type.rawValue
    }
}
