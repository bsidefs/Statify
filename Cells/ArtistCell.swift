//
//  ArtistCell.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class ArtistCell: SFTopsCell {
    
    // MARK: - Properties
    
    static let reuseID  = "ArtistCell"
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabelConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    
    func makeImageCircular() {
        imageView.layer.cornerRadius    = imageView.bounds.width / 2
        imageView.clipsToBounds         = true
    }
    
    
    func setLabelConstraints() {
        let padding: CGFloat            = 10
        
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            primaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            primaryLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func set(for artist: Artist) {
        self.primaryLabel.text          = artist.name
        // image network call
        NetworkManager.shared.downloadImage(from: artist.imageURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image    = image
                self.makeImageCircular()
            }
        }
    }
}
