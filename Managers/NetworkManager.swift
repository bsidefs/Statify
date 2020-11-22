//
//  NetworkManager.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import Foundation

/**
 * A Singleton which manages network calls to the Spotify Web API.
 */
class NetworkManager {
    
    // MARK: - Properties
    
    public static let shared    = NetworkManager()
    
    let cache                   = NSCache<NSString,UIImage>()
    let baseAPIEndpoint         = "https://api.spotify.com/v1/me"
    let baseTopsAPIEndpoint     = "https://api.spotify.com/v1/me/top"
    
    
    // MARK: - Initialization
    
    private init() {
        
    }
    
    
    // MARK: - Methods
    
    /**
     * Retrieves information about the user.
     */
    func getUser(
        using accessToken: String,
        completed: @escaping (Result<User,Error>) -> Void
    ){
        guard let url       = URL(string: baseAPIEndpoint) else { return }
        
        var request         = URLRequest(url: url)
        request.httpMethod  = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            if let data = data {
                do {
                    let decoder                 = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    var user                    = try decoder.decode(User.self, from: data)
                    
                    let json                    = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let followerCount           = JSONExtractor.decodeJSONToFollowerCount(json)
                    user.followerCount          = followerCount
                    
                    completed(.success(user))
                }
                catch {
                    completed(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    /**
     * Retrieves a user's Top Artists or Top Tracks.
     */
    func getTops(
        category: TopsCategory,
        using accessToken: String,
        completed: @escaping (Result<Any,Error>) -> Void
    ){
        let endpoint        = "\(baseTopsAPIEndpoint)/\(category.rawValue)"
        guard let url       = URL(string: endpoint) else { return }
        
        var request         = URLRequest(url: url)
        request.httpMethod  = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error) }
            
            if let data = data {
                do {
                    let json        = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let tops        = JSONExtractor.decodeJSONToTops(json, into: category)
                    completed(.success(tops))
                }
                catch {
                    completed(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    /**
     * Retrieves a user's playlists.
     *
     * Currently, only being used to get the count.
     */
    func getPlaylists(
        using accessToken: String,
        completed: @escaping (Result<Int,Error>) -> Void
    ){
        let endpoint        = "\(baseAPIEndpoint)/playlists"
        guard let url       = URL(string: endpoint) else { return }
        
        var request         = URLRequest(url: url)
        request.httpMethod  = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            if let data = data {
                do {
                    let json            = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let playlistCount   = JSONExtractor.decodeJSONToPlaylistCount(json)
                    completed(.success(playlistCount))
                }
                catch {
                    completed(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    /**
     * Retrieves a user's list of followed artists.
     *
     * Currently, only being used to get the count.
     */
    func getFollowing(
        using accessToken: String,
        completed: @escaping (Result<Int,Error>) -> Void
    ){
        let endpoint        = "\(baseAPIEndpoint)/following?type=artist"
        guard let url       = URL(string: endpoint) else { return }
        
        var request         = URLRequest(url: url)
        request.httpMethod  = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print(error) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            if let data = data {
                do {
                    let json            = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let followingCount  = JSONExtractor.decodeJSONToFollowingCount(json)
                    completed(.success(followingCount))
                }
                catch {
                    completed(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    /**
     * Retrieves the image for an artist or track.
     */
    func downloadImage(
        from url: String,
        completed: @escaping (UIImage?) -> Void
        ){
        
        // check the cache first
        let cacheKeyFromImageURL    = NSString(string: url)
        if let image                = cache.object(forKey: cacheKeyFromImageURL) {
            completed(image)
            return
        }
        
        // else proceed to download image
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let response  = response as? HTTPURLResponse, response.statusCode == 200,
                  let data      = data,
                  let image     = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            // now just add the image to the cache on the way out
            self.cache.setObject(image, forKey: cacheKeyFromImageURL)
            
            completed(image)
        }
        task.resume()
    }
}

