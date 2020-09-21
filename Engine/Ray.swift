//
//  Ray.swift
//  Engine
//
//  Created by Katz, Billy on 9/20/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Ray {
    public let origin, direction: Vector
    
    public init(origin: Vector, direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
}
