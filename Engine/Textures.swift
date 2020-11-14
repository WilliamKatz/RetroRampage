//
//  Textures.swift
//  Engine
//
//  Created by Katz, Billy on 11/14/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

public enum Texture: String, CaseIterable, Hashable {
    case wall, wall2
    case floor, ceiling
    case crackWall, crackWall2
    case slimeWall, slimeWall2
    case crackFloor
}

public struct Textures {
    private let textures: [Texture: Bitmap]
}

public extension Textures {
    init(loader: (String) -> Bitmap) {
        var textures = [Texture:Bitmap]()
        for texture in Texture.allCases {
            textures[texture] = loader(texture.rawValue)
        }
        self.init(textures: textures)
    }
    
    subscript(_ texture: Texture) -> Bitmap {
        return textures[texture]!
    }
}
