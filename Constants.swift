//
//  Constants.swift
//  Statify
//
//  Created by Brian Tamsing on 11/4/20.
//

import Foundation

enum ProfileStatType: String {
    
    case following      = "Following"
    case followers      = "Followers"
    case playlists      = "Playlists"
}

enum TopsCategory: String {
    case artists        = "artists"
    case tracks         = "tracks"
}

enum TokenType: String {
    
    case accessToken    = "access_token"
    case refreshToken   = "refresh_token"
}
