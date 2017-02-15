//
//  MenuScene.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 17/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds


class MenuScene: SKScene {
    var viewController: GameViewController!
    var bannerView: GADBannerView!
    
    var playLabel = SKLabelNode()
    var settingLabel = SKLabelNode()
    
    var easyLabel = SKLabelNode()
    var medLabel = SKLabelNode()
    var hardLabel = SKLabelNode()
    
    
    var buttonLayer = SKNode()
    
    var difficulty: TimeInterval = Difficulty.easy
    var difficultyOptions: Array<SKNode> = []
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        /* Configure and add background */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(buttonLayer)
        
        difficultyOptions = [easyLabel,
                             medLabel,
                             hardLabel]
        
        let centre = CGPoint(x: 0, y: 0)
        configureLabelNode(node: playLabel, text: "PLAY", position: centre, layer: buttonLayer)
        let settingLblPos = CGPoint(x: 0, y: playLabel.position.y - playLabel.frame.height * 2)
        configureLabelNode(node: settingLabel, text: "SETTING", position: settingLblPos, layer: buttonLayer)

        let easyLblPos = CGPoint(x: 0, y: settingLabel.position.y - settingLabel.frame.height * 2)
        configureLabelNode(node: easyLabel, text: "EASY", position: easyLblPos, layer: buttonLayer)
        
        let medLblPos = CGPoint(x: 0, y: easyLabel.position.y - easyLabel.frame.height * 2)
        configureLabelNode(node: medLabel, text: "MEDIUM", position: medLblPos, layer: buttonLayer)
        
        let hardLblPos = CGPoint(x: 0, y: medLabel.position.y - medLabel.frame.height * 2)
        configureLabelNode(node: hardLabel, text: "HARD", position: hardLblPos, layer: buttonLayer)
        
        
        

        
    }
    
    func configureLabelNode(node: SKLabelNode, text: String, position: CGPoint, layer: SKNode) {
        node.text = text
        node.fontSize = size.width / 10
        node.fontName = "AvenirNext-Bold"
        node.position = position
        node.zPosition = 10
        layer.addChild(node)
    }
    
    
    override func didMove(to view: SKView) {
        if bannerView == nil {
            initializeBanner()
        }
        loadRequest()
    }
    
    func loadRequest() {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]//, "22ed9df524b90565f5e15t23ad232415"]
        bannerView.load(request)
    }
    
    func initializeBanner() {
        // Create a banner ad and add it to the view hierarchy.
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = viewController
        view!.addSubview(bannerView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        let touch = touches.first
        let location = touch?.location(in: buttonLayer)
        let touchedNode = buttonLayer.nodes(at: location!).first
        
        if touchedNode == playLabel {
            let scene: SKScene = GameScene(size: self.size, difficulty: difficulty)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
        }
        
        if touchedNode != nil && difficultyOptions.contains(touchedNode!) {
            setDifficulty(node: touchedNode!)
        }
    }
    
    func setDifficulty(node: SKNode) {
        print("old mode: \(difficulty)")
        switch node {
        case easyLabel: difficulty = Difficulty.easy
        case medLabel: difficulty = Difficulty.med
        case hardLabel: difficulty = Difficulty.hard
        default: break
        }
        print("new mode: \(difficulty)")
        
    }
    

}
