//
//  StatsVC.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: - Properties
    
    var profileVC                   : ProfileVC!
    var profileContainerView        = UIView()
    
    var topArtistsVC                : TopArtistsVC!
    var topArtistsContainerView     = UIView()
    
    var topTracksVC                 : TopTracksVC!
    var topTracksContainerView      = UIView()
    
    var scrollView                  : UIScrollView!
    var contentView                 : UIView!
    
    var user                        : User!
    var tokens                      = UserDefaults.standard.value(forKey: "tokens") as! [String:String]
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        
        configureScrollView()
        configureChildContainerViews()
        
        configureProfileVC()
        getTopArtists()
        getTopTracks()
    }
    
    
    // MARK: - Methods
    
    func configureViewController() {
        title                                                               = "Your Spotify"
        view.backgroundColor                                                = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles              = true
    }
    
    
    func configureScrollView() {
        scrollView                                                          = UIScrollView()
        scrollView.showsVerticalScrollIndicator                             = false
        scrollView.translatesAutoresizingMaskIntoConstraints                = false
        
        contentView                                                         = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints               = false
        
        view.addSubview(scrollView)
        scrollView.pinSelfToEdges(of: view)
        
        scrollView.addSubview(contentView)
        contentView.pinSelfToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    
    /**
     * Configures the container views for the profile, top artists, and top tracks child view controllers.
     */
    func configureChildContainerViews() {
        profileContainerView                                                = UIView(frame: .zero)                              
        profileContainerView.translatesAutoresizingMaskIntoConstraints      = false
        contentView.addSubview(profileContainerView)
        
        topArtistsContainerView                                             = UIView(frame: .zero)
        topArtistsContainerView.translatesAutoresizingMaskIntoConstraints   = false
        contentView.addSubview(topArtistsContainerView)
        
        topTracksContainerView                                              = UIView(frame: .zero)
        topTracksContainerView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.addSubview(topTracksContainerView)
        
        let topPadding  : CGFloat = 15
        let sidePadding : CGFloat = 20
        
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: sidePadding),
            profileContainerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            profileContainerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),
            profileContainerView.heightAnchor.constraint(equalToConstant: 110),
            
            topArtistsContainerView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: topPadding),
            topArtistsContainerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            topArtistsContainerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            topArtistsContainerView.heightAnchor.constraint(equalToConstant: 235),
            
            topTracksContainerView.topAnchor.constraint(equalTo: topArtistsContainerView.bottomAnchor, constant: topPadding),
            topTracksContainerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            topTracksContainerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            topTracksContainerView.heightAnchor.constraint(equalToConstant: 235)
        ])
    }
    
    
    // --- PROFILE ---
    func configureProfileVC() {
        profileVC = ProfileVC(tokens: self.tokens)
        addChildVC(profileVC, to: profileContainerView)
    }
    
    
    // --- TOP ARTISTS ---
    func configureTopArtistsVC(_ artists: [Artist]) {
        topArtistsVC = TopArtistsVC(tokens: self.tokens, artists: artists)
        addChildVC(topArtistsVC, to: topArtistsContainerView)
    }
    
    
    func getTopArtists() {
        NetworkManager.shared.getTops(category: TopsCategory.artists, using: self.tokens[TokenType.accessToken.rawValue]!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let artists):
                    DispatchQueue.main.async { self.configureTopArtistsVC(artists as! [Artist]) }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    // --- TOP TRACKS ---
    func configureTopTracksVC(tracks: [Track]) {
        topTracksVC = TopTracksVC(tokens: self.tokens, tracks: tracks)
        addChildVC(topTracksVC, to: topTracksContainerView)
    }
    
    
    func getTopTracks() {
        NetworkManager.shared.getTops(category: TopsCategory.tracks, using: self.tokens[TokenType.accessToken.rawValue]!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let tracks):
                    DispatchQueue.main.async { self.configureTopTracksVC(tracks: tracks as! [Track]) }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    /**
     * Adds a child view controller to it's corresponding container view within this view controller.
     */
    func addChildVC(_ child: UIViewController, to containerView: UIView) {
        addChild(child)
        
        containerView.addSubview(child.view)
        child.view.frame = containerView.bounds
        
        child.didMove(toParent: self)
    }
}
