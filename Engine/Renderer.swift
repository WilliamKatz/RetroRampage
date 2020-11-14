    //
    //  Renderer.swift
    //  Engine
    //
    //  Created by Katz, Billy on 9/14/20.
    //  Copyright © 2020 KillyBatz. All rights reserved.
    //
    
    public struct Renderer {
        public private(set) var bitmap: Bitmap
        private let textures: Textures
        
        public init(width: Int, height: Int, textures: Textures) {
            self.bitmap = Bitmap(width: width, height: height, color: .black)
            self.textures = textures
        }
    }
    
    
    public extension Renderer {
        mutating func draw(_ world: World) {
            
            // Calculate the view plane
            let focalLength = 1.0
            let viewWidth = Double(world.map.width) / Double(world.map.height)
            let viewPlane = world.player.direction.orthogonal * viewWidth
            let viewCenter = world.player.position + world.player.direction * focalLength
            let viewStart = viewCenter - viewPlane / 2
            
            // Draw Player's field of view
            let columns = bitmap.width
            let step = viewPlane / Double(columns)
            var columnPosition = viewStart
            for x in 0..<columns {
                let rayDirection = columnPosition - world.player.position
                let viewPlaneDistance = rayDirection.length
                let ray = Ray(
                    origin: world.player.position,
                    direction: rayDirection / viewPlaneDistance
                )
                let end = world.map.hitTest(ray)
                
                /// draw the wall
                let wallDistance = (end - ray.origin).length
                let wallHeight = 1.0
                
                let distanceRatio = viewPlaneDistance / focalLength
                let perpendicular = wallDistance / distanceRatio
                let height = wallHeight * focalLength / perpendicular * Double(bitmap.height)

                /// Draw columns with bitmap
                let wallX: Double
                let wallTexture: Bitmap
                let tile = world.map.tile(at: end, from: ray.direction)
                if end.x.rounded(.down) == end.x {
                    wallX = end.y - end.y.rounded(.down)
                    wallTexture = textures[tile.textures[0]]
                } else {
                    wallX = end.x - end.x.rounded(.down)
                    wallTexture = textures[tile.textures[1]]
                }
                
                let textureX = Int(wallX * Double(wallTexture.width))
                let wallStart = Vector(x: Double(x), y: (Double(bitmap.height)-height)/2 - 0.001)
                bitmap.drawColumn(textureX, of: wallTexture, at: wallStart, height: height)
                
                
                /// Lets draw a floor and the ceiling !
                /// these are set with the cached value or a new value when the cache expires
                var floorTile: Tile!
                var floorTexture, ceilingTexture: Bitmap!
                let floorStart = Int(wallStart.y + height) + 1
                for y in min(floorStart, bitmap.height) ..< bitmap.height {
                    let normalizedY = (Double(y) / Double(bitmap.height)) * 2 - 1
                    let perpendicular = wallHeight * focalLength / normalizedY
                    let distance = perpendicular * distanceRatio
                    let mapPosition = ray.origin + rayDirection * distance
                    let tileX = mapPosition.x.rounded(.down), tileY = mapPosition.y.rounded(.down)
                    let textureX = mapPosition.x - tileX, textureY = mapPosition.y - tileY
                    
                    // grabt the tile from the world map to determine which texture to draw
                    let tile = world.map[Int(tileX), Int(tileY)]
                    if tile != floorTile {
                        floorTexture = textures[tile.textures[0]]
                        ceilingTexture = textures[tile.textures[1]]
                        floorTile = tile
                    }
                    bitmap[x, y] = floorTexture[normalized: textureX, textureY]
                    bitmap[x, bitmap.height - 1 - y] = ceilingTexture[normalized: textureX, textureY]
                }
                
                
                columnPosition += step
                
            }
        }
    }
