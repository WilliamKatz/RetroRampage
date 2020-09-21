//
//  Bitmap.swift
//  GamePlatform
//
//  Created by Katz, Billy on 9/14/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public struct Bitmap {
    public private(set) var pixels: [Color]
    public let width: Int
    
    public init(width: Int, pixels: [Color]) {
        self.width = width
        self.pixels = pixels
    }
}

public extension Bitmap {
    var height: Int {
        return pixels.count / width
    }
    
    subscript(x: Int, y: Int) -> Color {
        get { return pixels[y * width + x] }
        set {
            guard x >= 0, y >= 0, x < width, y < height else { return }
            pixels[y * width + x] = newValue
            
        }
    }
    
    init(width: Int, height: Int, color: Color) {
        self.pixels = Array(repeating: color, count: width * height)
        self.width = width
    }
    
    mutating func fill(rect: Rect, color: Color) {
        for y in Int(rect.min.y) ..< Int(rect.max.y) {
            for x in Int(rect.min.x) ..< Int(rect.max.x) {
                self[x, y] = color
            }
        }
    }
    
    mutating func drawLine(from: Vector, to: Vector, color: Color) {
        let difference = to - from
        let steps: Double
        let smallStep: Vector
        if abs(difference.x) > abs(difference.y) {
            steps = abs(difference.x).rounded(.up)
            let sign: Double = difference.x > 0 ? 1 : -1
            smallStep = Vector(x: 1, y: difference.y / difference.x) * sign
        } else {
            steps = abs(difference.y).rounded(.up)
            let sign: Double = difference.y > 0 ? 1 : -1
            smallStep = Vector(x: difference.x / difference.y, y: 1) * sign
        }
        
        var point = from
        for _ in 0..<Int(steps) {
            self[Int(point.x), Int(point.y)] = color
            point += smallStep
        }
        
    }
}
