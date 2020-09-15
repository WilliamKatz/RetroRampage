//
//  Player.swift
//  Engine
//
//  Created by Katz, Billy on 9/14/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Player {
    public var position: Vector
    public var velocity: Vector
    public var radius: Double = 0.5
    
    public init(position: Vector) {
        self.position = position
        self.velocity = Vector(x: 2, y: 4)
    }
    
    public var rect: Rect {
        let halfsize = Vector(x: radius, y: radius)
        return Rect(min: position-halfsize, max: position+halfsize)
    }
}
