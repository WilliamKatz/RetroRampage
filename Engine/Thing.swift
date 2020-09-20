//
//  Thing.swift
//  Engine
//
//  Created by Katz, Billy on 9/19/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public enum Thing: Int, Decodable {
    case nothing
    case player
    case pillar
    
    var isPillar: Bool {
        switch self {
        case .pillar:
            return true
        case .nothing, .player:
            return false
        }
    }
}
