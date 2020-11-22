//
//  AuthManager.swift
//  Statify
//
//  Created by Brian Tamsing on 11/5/20.
//

import Foundation
import AuthenticationServices

/**
 * A Singleton which manages application authorization through the Spotify Web API.
 */
class AuthManager {
    
    // MARK: - Properties
    
    static let shared                   = AuthManager()
    
    let baseAuthEndpoint                = "https://accounts.spotify.com/authorize"
    let baseTokenRequestEndpoint        = "https://accounts.spotify.com/api/token"
    
    private let clientID                = "139c6f747bca495484cd195d71c577d1"
    private let clientKey               = "38becc2dcf4e41a9b37dc1d2c1337b0e"
    
    let redirectURI                     = "statify://spotify-login-callback"
    let grantType                       = "authorization_code"
    
    
    // MARK: - Initialization
    
    private init() {
        
    }
    
    
    // MARK: - Methods
    
    /**
     * Requests authorization access/refresh tokens from the Spotify Web API.
     */
    func requestTokens(
        authCode: String,
        completed: @escaping (Result<Any,Error>) -> Void
    ){
        // get the encoding
        let clientIDAndKey          = "\(clientID):\(clientKey)"
        let utf8String              = clientIDAndKey.data(using: .utf8)
        guard let base64Encoding    = utf8String?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else { return }
        
        // base endpoint
        guard let url               = URL(string: baseTokenRequestEndpoint) else { return }
        
        // construct the query
        var components              = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems       = [
            URLQueryItem(name: "grant_type", value: grantType),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
        let query                   = components.url?.query
        
        // url request
        var request                 = URLRequest(url: url)
        request.httpMethod          = "POST"
        request.httpBody            = Data(query!.utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Encoding)", forHTTPHeaderField: "Authorization")
        
        // task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error) }   // sufficient for this project's purposes. present error alert otherwise.
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completed(.success(json))
                }
                catch {
                    completed(.failure(error))
                }
            }
        }
        task.resume()
    }
}
