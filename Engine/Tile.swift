//
//  Tile.swift
//  Engine
//
//  Created by Katz, Billy on 9/15/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public enum Tile: Int, Decodable {
    case floor
    case wall
}

public extension Tile {
    var isWall: Bool {
        switch self {
        case .wall:
            return true
        case .floor:
            return false
        }
    }
}


public struct Tilemap: Decodable {
    private let tiles: [Tile]
    public let things: [Thing]
    public let width: Int
}

public extension Tilemap {
    var height: Int {
        return tiles.count / width
    }
    
    var size: Vector {
        return Vector(x: Double(width), y: Double(height))
    }
    
    subscript(x: Int, y: Int) -> Tile {
        return tiles[y * width + x]
    }
}
