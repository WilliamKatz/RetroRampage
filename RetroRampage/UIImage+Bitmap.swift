//
//  UIImage+Bitmap.swift
//  RetroRampage
//
//  Created by Katz, Billy on 9/14/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

import UIKit
import Engine

extension Bitmap {
    init?(uiimage: UIImage) {
        guard let cgImage = uiimage.cgImage else { return nil }
        
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<Color>.size
        let bytesPerRow = cgImage.width * bytesPerPixel
        
        var pixels = [Color](repeating: .clear, count: cgImage.width * cgImage.height)
        
        guard let context = CGContext(data: &pixels,
                                      width: cgImage.width,
                                      height: cgImage.height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: alphaInfo.rawValue)
        else {
            return nil
        }
        
        
        // this draws the image and populates the [Color]
        context.draw(cgImage, in: CGRect(origin: .zero, size: uiimage.size))
        self.init(width: cgImage.width, pixels: pixels)
    }
}

extension UIImage {
    
    convenience init?(bitmap: Bitmap) {
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<Color>.size
        let bytesPerRow = bitmap.width * bytesPerPixel
        
        guard let providerRef = CGDataProvider(data: Data(bytes: bitmap.pixels, count: bitmap.height * bytesPerRow) as CFData) else {
            return nil
        }
        
        guard let cgImage = CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow:  bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }
            
        self.init(cgImage: cgImage)
    }
}
