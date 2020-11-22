//
//  TopArtistsVC.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class TopArtistsVC: SFGridController {
    
    // MARK: - Properties
    
    var artists : [Artist]!
    var tokens  : [String:String]!

    
    // MARK: - Initialization
    
    init(tokens: [String:String], artists: [Artist]) {
        super.init(title: "Top Artists")
        self.tokens     = tokens
        self.artists    = artists
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    
    // MARK: - Methods
    
    override func configureCollectionView() {
        super.configureCollectionView()
        
        // delegate and data source
        collectionView.delegate             = self
        collectionView.dataSource           = self
        
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseID)
    }
}


// MARK: - Extensions

extension TopArtistsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.reuseID, for: indexPath) as! ArtistCell
        cell.set(for: self.artists[indexPath.item])
        
        return cell
    }
}


extension TopArtistsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
}

