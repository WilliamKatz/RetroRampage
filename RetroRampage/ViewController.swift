//
//  ViewController.swift
//  RetroRampage
//
//  Created by Katz, Billy on 3/16/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

import UIKit
import Engine

private let joystickRadius: Double = 40
private let maximumTimeStep: Double = 1 / 20
private let worldTimeStep: Double = 1 / 120

func loadTextures() -> Textures {
    /// Pipes all the textures defined in the Texture enum to images in Assets.xcassets using an extension on Bitmap
    Textures { (textureName) -> Bitmap in
        let texture = UIImage(named: textureName)!
        return Bitmap(uiimage: texture)!
    }
}

class ViewController: UIViewController {
    
    private let imageView = UIImageView()
    private var world = World(map: loadMap())
    private var lastFrameTime = CACurrentMediaTime()
    private let panGesture = UIPanGestureRecognizer()
    private var extraWorldTimeSteps: Double = 0
    private let textures = loadTextures()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
        
        /// gestures
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        let timeStep = min(maximumTimeStep, displayLink.timestamp - lastFrameTime)
        
        /// Create the input
        let inputVector = self.inputVector
        let rotation = inputVector.x * world.player.turningSpeed * worldTimeStep
        let input = Input(speed: -inputVector.y, rotation: Rotation(sine: sin(rotation), cosine: cos(rotation)))
        
        /// Round down to get the whole number (add extra times from the previos loop)
        let worldSteps = (timeStep / worldTimeStep + extraWorldTimeSteps).rounded(.down)
        
        /// Save the remainder so that we can factor it in the next update loop
        extraWorldTimeSteps = max(0, (timeStep / worldTimeStep) - worldSteps)
        
        /// Perform worldSteps # of updates frame. For frame rates above 120, this could be zero
        for _ in 0 ..< Int(worldSteps) {
            world.update(timeStep: timeStep / worldSteps, input: input)
        }
        lastFrameTime = displayLink.timestamp
        
        let width = Int(imageView.bounds.width), height = Int(imageView.bounds.height)
        var renderer = Renderer(width: width, height: height, textures: textures)
        renderer.draw(world)
        
        imageView.image = UIImage(bitmap: renderer.bitmap)
    }
    
    
    func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.magnificationFilter = .nearest
    }
    
    private var inputVector: Vector {
        switch panGesture.state {
        case .began, .changed:
            let translation = panGesture.translation(in: view)
            var vector = Vector(x: Double(translation.x), y: Double(translation.y))
            vector /= max(joystickRadius, vector.length)
            panGesture.setTranslation(CGPoint(
                x: vector.x * joystickRadius,
                y: vector.y * joystickRadius
            ), in: view)
            return vector
        default:
            return Vector(x: 0, y: 0)
        }
    }
    
}


private func loadMap() -> Tilemap {
    let jsonURL = Bundle.main.url(forResource: "Map", withExtension: ".json")!
    let jsonData = try! Data(contentsOf: jsonURL)
    return try! JSONDecoder().decode(Tilemap.self, from: jsonData)
}
