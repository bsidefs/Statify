//
//  User.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import Foundation

struct User: Decodable {
    
    // MARK: - Properties
    
    let displayName     : String
    
    var followerCount   = 0
    var followingCount  = 0
    var playlistCount   = 0
}

// MARK: - Extension

extension User {
    private enum CodingKeys: CodingKey {
        case displayName
    }
}
