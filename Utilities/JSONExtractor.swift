//
//  JSONExtractor.swift
//  Statify
//
//  Created by Brian Tamsing on 11/5/20.
//

import Foundation

/**
 * A structure used to extract data from the JSON received from the Spotify Web API.
 */
struct JSONExtractor {
    
    // --- DECODING ---
    
    /**
     * Decodes JSON to obtain the current user's following count.
     */
    static func decodeJSONToFollowingCount(_ json: Any) -> Int {
        var followingCount      = 0
        
        if let json             = json as? [String:Any] {
            if let artists      = json["artists"] as? [String:Any] {
                if let value    = artists["total"] as? Int {
                    followingCount = value
                }
            }
        }
        
        return followingCount
    }
    
    
    /**
     * Decodes JSON to obtain the current user's playlist count.
     */
    static func decodeJSONToPlaylistCount(_ json: Any) -> Int {
        var playlistCount       = 0
        
        if let json         = json as? [String:Any] {
            if let value    = json["total"] as? Int {
                playlistCount   = value
            }
        }
        
        return playlistCount
    }
    
    
    /**
     * Decodes JSON to obtain the current user's follower count.
     */
    static func decodeJSONToFollowerCount(_ json: Any) -> Int {
        var followerCount   : Int
        
        let followers       = JSONExtractor.extractDict(from: json, for: "followers")
        followerCount       = followers["total"] as! Int
        
        return followerCount
    }
    
    
    /**
     * Decodes JSON into the appropriate Model type.
     */
    static func decodeJSONToTops(_ json: Any, into category: TopsCategory) -> Array<Any> {
        let array       = JSONExtractor.extractDictArray(from: json, for: "items")

        var tops        = [Any]()
        
        var name        = ""
        var imageURL    = ""
        
        var artist      : Artist!

        // value accessing...
        for dict in array {
            for (key,value) in dict {
                if key == "name" {  // artist/track name
                    name = value as! String
                }
                else if key == "images" {   // artist image
                    let images  = value as! [[String:Any]]
                    imageURL    = images[0]["url"] as! String
                }
                else if key == "album" {    // track image
                    let album   = value as! [String:Any]
                    let images  = album["images"] as! [[String:Any]]
                    imageURL    = images[0]["url"] as! String
                    
                    // if track, then get the artist name as well
                    if category == TopsCategory.tracks {
                        let artists = album["artists"] as! [[String:Any]]
                        let info    = artists[0]
                        
                        let name    = info["name"] as! String
                        artist      = Artist(name: name)
                    }
                }
            }
            
            // create model instances
            if category == TopsCategory.artists {
                let top = Artist(name: name, imageURL: imageURL)
                tops.append(top)
            }
            else {
                let top = Track(title: name, artist: artist, imageURL: imageURL)
                tops.append(top)
            }
        }
        
        return tops
    }
    
    
    // --- EXTRACTIONS ---
    
    static func extractDict(from json: Any, for key: String) -> Dictionary<String,Any> {
        var dict                = [String:Any]()
        
        if let json             = json as? [String:Any]  {
            if let value        = json[key] as? [String:Any] {
                dict            = value
            }
        }
        
        return dict
    }
    
    /**
     * Returns a dictionary of String:String from a JSON object.
     */
    static func extractStringDict(from json: Any, for keys: String...) -> Dictionary<String,String> {
        var dict                = [String:String]()
        
        if let json             = json as? [String:Any] {
            for key in keys {
                if let value    = json[key] as? String {
                    dict[key]   = value
                }
            }
        }
        return dict
    }
    
    
    /**
     * Returns an array of dictionaries from a JSON object.
     */
    static func extractDictArray(from json: Any, for keys: String...) -> Array<Dictionary<String,Any>> {
        var array               = [[String:Any]]()
        
        if let json             = json as? [String:Any] {
            for key in keys {
                if let value    = json[key] as? [[String:Any]] {
                    array       = value
                }
            }
        }
        
        return array
    }
}
