//
//  TopTracksVC.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class TopTracksVC: SFGridController {

    // MARK: - Properties
    
    var tracks  : [Track]!
    var tokens  : [String:String]!
    
    
    // MARK: - Initialization
    
    init(tokens: [String:String], tracks: [Track]) {
        super.init(title: "Top Tracks")
        self.tokens = tokens
        self.tracks = tracks
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
        collectionView.delegate         = self
        collectionView.dataSource       = self
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.reuseID)
    }
}


// MARK: - Extensions

extension TopTracksVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseID, for: indexPath) as! TrackCell
        cell.set(track: self.tracks[indexPath.item])
        
        return cell
    }
}


extension TopTracksVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
}
