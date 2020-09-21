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
        self.bitmap = Bitmap(width: width, height: height, color: .black)
    }
}


public extension Renderer {
    mutating func draw(_ world: World) {
        let scale = Double(bitmap.height) / world.size.y
        // Draw map
        for y in 0..<world.map.height {
            for x in 0..<world.map.width where world.map[x,y].isWall {
                if world.map[x,y].isWall {
                    let rect = Rect(
                        min: Vector(x: Double(x), y: Double(y)) * scale,
                        max: Vector(x: Double(x+1), y: Double(y+1)) * scale
                    
                    )
                    bitmap.fill(rect: rect, color: .white)
                } else if world.map.things[y * world.map.width + x].isPillar {
                    let rect = Rect(
                        min: Vector(x: Double(x), y: Double(y)) * scale,
                        max: Vector(x: Double(x+1), y: Double(y+1)) * scale
                    
                    )
                    bitmap.fill(rect: rect, color: .green)
                }
            }
        }
        
        // Draw Player
        var rect = world.player.rect
        rect.min *= scale
        rect.max *= scale
    
        // Draw Player's line of sight
        let ray = Ray(origin: world.player.position, direction: world.player.direction)
        let end = world.map.hitTest(ray)
        bitmap.drawLine(from: world.player.position * scale, to: end * scale, color: .red)
        bitmap.fill(rect: rect, color: .blue)
    }
}
