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
    public var radius: Double = 0.25
    public let speed: Double = 2
    
    public init(position: Vector) {
        self.position = position
        self.velocity = Vector(x: 0, y: 0)
    }
    
    public var rect: Rect {
        let halfsize = Vector(x: radius, y: radius)
        return Rect(min: position-halfsize, max: position+halfsize)
    }
}

public extension Player {
    func intersection(with map: Tilemap) -> Vector? {
        let minX = Int(rect.min.x), maxX = Int(rect.max.x)
        let minY = Int(rect.min.y), maxY = Int(rect.max.y)
        var largestIntersection: Vector?
        for y in minY ... maxY {
            for x in minX ... maxX where map[x, y].isWall {
                let wallRect = Rect(
                    min: Vector(x: Double(x), y: Double(y)),
                    max: Vector(x: Double(x + 1), y: Double(y + 1))
                )
                if let intersection = rect.intersection(with: wallRect),
                    intersection.length > largestIntersection?.length ?? 0 {
                    largestIntersection = intersection
                }
            }
        }
        return largestIntersection
    }
}
