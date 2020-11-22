//
//  SFGridController.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

/**
 * Represents a VC with a horizontal UICollectionView.
 */
class SFGridController: UIViewController {
    
    // MARK: - Properties
    
    var titleLabel      = UILabel(frame: .zero)
    var collectionView  : UICollectionView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitleLabel()
        configureCollectionView()
        layoutUI()
    }
    
    
    // MARK: - Initialization
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Methods
    
    func configureTitleLabel() {
        titleLabel.font                                             = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureCollectionView() {
        let layout                                                  = UICollectionViewFlowLayout()
        let inset: CGFloat                                          = 20
        
        layout.scrollDirection                                      = .horizontal
        layout.sectionInset                                         = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionView                                              = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor                              = .systemBackground
        collectionView.showsHorizontalScrollIndicator               = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
    }
    
    
    func layoutUI() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        let padding: CGFloat                    = 20
        let collectionViewTopPadding: CGFloat   = 10
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: collectionViewTopPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 195)
        ])
    }
}

