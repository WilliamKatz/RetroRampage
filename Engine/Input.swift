//
//  Input.swift
//  Engine
//
//  Created by Katz, Billy on 9/19/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Input {
    public var speed: Double
    public var rotation: Rotation
    
    public init(speed: Double, rotation: Rotation) {
        self.speed = speed
        self.rotation = rotation
    }
}
