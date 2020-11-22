//
//  TrackCell.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class TrackCell: SFTopsCell {
    
    // MARK: - Properties
    
    static let reuseID  = "TrackCell"
    
    let artistLabel     = UILabel()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureArtistLabel()  // additional label for a track cell  (the track title is the "primary" label defined in the superclass)
        setLabelConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    func setLabelConstraints() {
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            primaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            primaryLabel.heightAnchor.constraint(equalToConstant: 15),
            
            artistLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    
    func configureArtistLabel() {
        artistLabel.font                                        = UIFont.systemFont(ofSize: 12, weight: .medium)
        artistLabel.textAlignment                               = .center
        artistLabel.translatesAutoresizingMaskIntoConstraints   = false
        
        addSubview(artistLabel)
    }
    
    
    func set(track: Track) {
        self.primaryLabel.text          = track.title
        self.artistLabel.text           = track.artist.name
        // image network call
        NetworkManager.shared.downloadImage(from: track.imageURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.imageView.image     = image }
        }
    }
}
