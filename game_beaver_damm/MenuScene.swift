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
    
    var buttonLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        /* Configure and add background */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(buttonLayer)
        
        // Start Label
        playLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playLabel.text = "PLAY"
        playLabel.fontSize = size.width / 10
        playLabel.position = CGPoint(x: 0, y: 0)
        buttonLayer.zPosition = 10
        buttonLayer.addChild(playLabel)
        
        // Setting
        settingLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        settingLabel.text = "SETTING"
        settingLabel.fontSize = size.width / 10
        settingLabel.position = CGPoint(x: 0, y: 0 - playLabel.frame.height)
        buttonLayer.zPosition = 10
        buttonLayer.addChild(settingLabel)
        
        // Score
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
            let scene: SKScene = GameScene(size: self.size)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
        }
    }
    

}
