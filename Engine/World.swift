//
//  World.swift
//  Engine
//
//  Created by Katz, Billy on 9/15/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct World {
    public let size: Vector
    public var player: Player
    
    public init() {
        self.size = Vector(x: 8, y: 8)
        self.player = Player(position: Vector(x: 4, y: 4))
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
}

