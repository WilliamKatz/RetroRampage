//
//  Renderer.swift
//  Engine
//
//  Created by Katz, Billy on 9/14/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Renderer {
    public private(set) var bitmap: Bitmap
    
    public init(width: Int, height: Int) {
        self.bitmap = Bitmap(width: width, height: height, color: .white)
    }
}


public extension Renderer {
    mutating func draw(_ world: World) {
        let scale = Double(bitmap.height) / world.size.y
        
        var rect = world.player.rect
        rect.min *= scale
        rect.max *= scale
        
        bitmap.fill(rect: rect, color: .blue)
    }
}
