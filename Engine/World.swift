//
//  World.swift
//  Engine
//
//  Created by Katz, Billy on 9/15/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct World {
    public let map: Tilemap
    public var player: Player
    
    public init(map: Tilemap) {
        self.map = map
        self.player = Player(position: map.size / 2)
    }
}

public extension World {
    mutating func update(timeStep: Double) {
        player.position += player.velocity * timeStep
        player.position.x += 8
        player.position.y += 8
        player.position.x.formTruncatingRemainder(dividingBy: 8)
        player.position.y.formTruncatingRemainder(dividingBy: 8)
    }
    
    var size: Vector {
        return map.size
    }
}

