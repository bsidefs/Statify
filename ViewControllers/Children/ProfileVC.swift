//
//  ProfileVC.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    var user                : User!
    var tokens              : [String:String]!
    
    var profileCardView     : UIView!
    var titleLabel          = UILabel(frame: .zero)
    var stackView           : UIStackView!

    var playlistStatView    : ProfileStatView!
    var followerStatView    : ProfileStatView!
    var followingStatView   : ProfileStatView!
    
    
    // MARK: - Initialization
    
    init(tokens: [String:String]) {
        super.init(nibName: nil, bundle: nil)
        self.tokens = tokens
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        
        configureProfileCard()
        configureTitleLabel()
        configureStackView()
        layoutProfileCard()
        
        getUser()
    }
    
    
    // MARK: - Methods
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
    }
    
    func configureProfileCard() {
        profileCardView                                             = UIView(frame: .zero)
        profileCardView.layer.cornerRadius                          = 8
        profileCardView.backgroundColor                             = .secondarySystemBackground
        profileCardView.translatesAutoresizingMaskIntoConstraints   = false
        
        view.addSubview(profileCardView)
    }
    
    
    func configureTitleLabel() {
        titleLabel.font                                             = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth                        = true
        titleLabel.translatesAutoresizingMaskIntoConstraints        = false
        
        profileCardView.addSubview(titleLabel)
    }
    
    
    func configureStackView() {
        stackView                                                   = UIStackView()
        stackView.axis                                              = .horizontal
        stackView.distribution                                      = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints         = false
        
        profileCardView.addSubview(stackView)
    }
    
    
    func layoutProfileCard() {
        self.playlistStatView   = ProfileStatView(statType: .playlists)
        stackView.addArrangedSubview(playlistStatView)
        
        self.followerStatView   = ProfileStatView(statType: .followers)
        stackView.addArrangedSubview(followerStatView)
        
        self.followingStatView  = ProfileStatView(statType: .following)
        stackView.addArrangedSubview(followingStatView)
        
        let topPadding  : CGFloat   = 5
        let sidePadding : CGFloat   = 10
        
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.topAnchor),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileCardView.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPadding),
            stackView.leadingAnchor.constraint(equalTo: profileCardView.leadingAnchor, constant: sidePadding),
            stackView.trailingAnchor.constraint(equalTo: profileCardView.trailingAnchor, constant: -sidePadding),
            stackView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    func getUser() {
        followerStatView.presentActivityIndicator()
        
        NetworkManager.shared.getUser(using: self.tokens[TokenType.accessToken.rawValue]!) { [weak self] result in
            guard let self = self else { return }
            self.followerStatView.dismissActivityIndicator()
            
            switch result {
                case .success(let user):
                    self.user = user
                    DispatchQueue.main.async {  // set name and follower count
                        self.titleLabel.text = self.user.displayName
                        self.followerStatView.setStat(self.user.followerCount)
                    } // then get playlists
                    self.getPlaylists()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    func getPlaylists() {
        playlistStatView.presentActivityIndicator()
        
        NetworkManager.shared.getPlaylists(using: self.tokens[TokenType.accessToken.rawValue]!) { [weak self] result in
            guard let self = self else { return }
            self.playlistStatView.dismissActivityIndicator()
            
            switch result {
                case .success(let playlistCount):
                    self.user.playlistCount = playlistCount
                    DispatchQueue.main.async {  // set playlist count
                        self.playlistStatView.setStat(playlistCount)
                    } // then get following
                    self.getFollowing()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    
    func getFollowing() {
        followingStatView.presentActivityIndicator()
        
        NetworkManager.shared.getFollowing(using: self.tokens[TokenType.accessToken.rawValue]!) { [weak self] result in
            guard let self = self else { return }
            self.followingStatView.dismissActivityIndicator()
            
            switch result {
                case .success(let followingCount):
                    self.user.followingCount = followingCount
                    DispatchQueue.main.async {  // set following count
                        self.followingStatView.setStat(followingCount)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
