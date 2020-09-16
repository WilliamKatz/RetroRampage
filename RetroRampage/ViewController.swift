//
//  ViewController.swift
//  RetroRampage
//
//  Created by Katz, Billy on 3/16/20.
//  Copyright © 2020 KillyBatz. All rights reserved.
//

import UIKit
import Engine

class ViewController: UIViewController {
    
    private let imageView = UIImageView()
    private var world = World(map: loadMap())
    private var lastFrameTime = CACurrentMediaTime()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        let timeStep = displayLink.timestamp - lastFrameTime
        world.update(timeStep: timeStep)
        lastFrameTime = displayLink.timestamp
        
        let size = Int(min(512, min(imageView.bounds.width, imageView.bounds.height)))
        var renderer = Renderer(width: size, height: size)
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


}


private func loadMap() -> Tilemap {
    let jsonURL = Bundle.main.url(forResource: "Map", withExtension: ".json")!
    let jsonData = try! Data(contentsOf: jsonURL)
    return try! JSONDecoder().decode(Tilemap.self, from: jsonData)
}
