//
//  Rect.swift
//  Engine
//
//  Created by Katz, Billy on 9/15/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Rect {
    var min, max: Vector
    
    public init(min: Vector, max: Vector) {
        self.min = min
        self.max = max
    }
    
}
