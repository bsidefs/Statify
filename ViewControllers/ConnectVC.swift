//
//  ConnectVC.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import UIKit
import AuthenticationServices

class ConnectVC: UIViewController {
    
    // MARK: - Properties
    
    let baseAuthEndpoint                = "https://accounts.spotify.com/authorize"
    
    private let clientID                = "139c6f747bca495484cd195d71c577d1"
    
    let responseType                    = "code"
    let redirectURI                     = "statify://spotify-login-callback"
    let scopes                          = "user-read-private+user-read-email+user-top-read+user-follow-read+playlist-read-private"

    private var authCode                : String!
    private var tokens                  : [String:String]!
    
    var titleLabel                      : UILabel!
    var connectButton                   : UIButton!

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureConnectButton()
        configureTitleLabel()
        setConstraints()
    }
    

    // MARK: - Methods
    
    func configureViewController() {
        view.backgroundColor                                    = .systemBackground
    }
    
    
    func configureConnectButton() {
        connectButton                                           = UIButton()
        connectButton.setTitle("Connect to Spotify", for: .normal)
        
        connectButton.layer.cornerRadius                        = 20
        connectButton.titleLabel?.font                          = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        connectButton.backgroundColor                           = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        connectButton.contentEdgeInsets                         = UIEdgeInsets(top: 11.75, left: 32.0, bottom: 11.75, right: 32.0)
        connectButton.sizeToFit()
        
        view.addSubview(connectButton)
        
        connectButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
    }
    
    
    func configureTitleLabel() {
        titleLabel                                              = UILabel()
        titleLabel.font                                         = UIFont.systemFont(ofSize: 36, weight: .medium)
        titleLabel.numberOfLines                                = 2
        titleLabel.text                                         = "Welcome to\nStatify"
        titleLabel.translatesAutoresizingMaskIntoConstraints    = false
        
        view.addSubview(titleLabel)
    }
    
    
    func setConstraints() {
        let topPadding: CGFloat = 200
        NSLayoutConstraint.activate([
            connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    @objc func didTapConnect() {
        requestAuth()
    }
    
    
    /**
     * Requests authorization access/refresh tokens from the Spotify Web API.
     */
    func requestAuth() {
        let endpoint                = "\(baseAuthEndpoint)?client_id=\(clientID)&response_type=\(responseType)&redirect_uri=\(redirectURI)&scope=\(scopes)"

        guard let url               = URL(string: endpoint) else { return }
        let scheme                  = redirectURI
        
        let session                 = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { [weak self] (callbackURL, error) in
            guard let self          = self else { return }
            
            if let error = error { print(error) }
            
            self.authCode           = callbackURL?.absoluteString.components(separatedBy: "=")[1]
            AuthManager.shared.requestTokens(authCode: self.authCode) { [weak self] result in
                guard let self      = self else { return }
                
                switch result {
                    case .success(let data):
                        self.tokens = JSONExtractor.extractStringDict(from: data, for: "access_token", "refresh_token")
                        self.pushStatsVC()
                        
                    case .failure(let error):
                        print(error)
                }
            }
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    
    /**
     * Persists a user's authorized state and stores their tokens.
     */
    func setAuthorizedUser() {
        let authKey     = "isAuthorized"
        UserDefaults.standard.set(true, forKey: authKey)
        
        let tokenKey    = "tokens"
        UserDefaults.standard.set(self.tokens, forKey: tokenKey)
    }
    
    
    func pushStatsVC() {
        setAuthorizedUser()
        DispatchQueue.main.async {
            let dest                                = StatsVC()
            
            let navController                       = UINavigationController(rootViewController: dest)
            navController.modalPresentationStyle    = .fullScreen
            
            self.present(navController, animated: true)
        }
    }
}


// MARK: - Extension

extension ConnectVC: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
}
