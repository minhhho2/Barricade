//
//  GameViewController.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 11/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // MARK: - Default functions
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        let size = skView.bounds.size
        let scene = MenuScene(size: size)
        
        scene.viewController = self
        
        scene.scaleMode = .aspectFill
        scene.size = size
        skView.isMultipleTouchEnabled = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
        
    }
}
