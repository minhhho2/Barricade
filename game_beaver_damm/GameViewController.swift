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
    
    var level: Level!

    
    // MARK: - Default functions
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
        //return [.landscapeLeft, .landscapeRight]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("game view controller")

        
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
