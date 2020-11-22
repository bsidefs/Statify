//
//  SFTopsCell.swift
//  Statify
//
//  Created by Brian Tamsing on 11/6/20.
//

import UIKit

class SFTopsCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let primaryLabel    = UILabel()
    let imageView       = UIImageView(frame: .zero)
    
    
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
        backgroundColor = .clear
        configurePrimaryLabel()
        configureImageView()
        setImageConstraint()
    }
    
    
    func configurePrimaryLabel() {
        primaryLabel.font                                       = UIFont.systemFont(ofSize: 14, weight: .medium)
        primaryLabel.textAlignment                              = .center
        primaryLabel.adjustsFontForContentSizeCategory          = true
        primaryLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        addSubview(primaryLabel)
    }
    
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints     = false
        
        addSubview(imageView)
    }
    
    
    func setImageConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
