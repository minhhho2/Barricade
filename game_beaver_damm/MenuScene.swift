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
    
    /* UI Label */
    var playLabel = SKLabelNode()
    var settingLabel = SKLabelNode()
    
    /* Mode UI Label */
    var easyLabel = SKLabelNode()
    var hardLabel = SKLabelNode()
    var selectedDifficultyLabel = SKSpriteNode()
    
    /* Layer */
    var buttonLayer = SKNode()
    
    /* Data */
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
        
        difficultyOptions = [easyLabel, hardLabel]
        
        let easyLblPos = CGPoint(x: -self.frame.width / 4, y: 0)
        configureLabelNode(node: easyLabel, text: "EASY", position: easyLblPos, layer: buttonLayer)
        
        let hardLblPos = CGPoint(x: self.frame.width / 4, y: 0)
        configureLabelNode(node: hardLabel, text: "HARD", position: hardLblPos, layer: buttonLayer)
        
        let playLblPos = CGPoint(x: 0, y: easyLabel.position.y + easyLabel.frame.height * 3)
        configureLabelNode(node: playLabel, text: "PLAY", position: playLblPos, layer: buttonLayer)
        
        let settingLblPos = CGPoint(x: 0, y: easyLabel.position.y - easyLabel.frame.height * 3)
        configureLabelNode(node: settingLabel, text: "SETTING", position: settingLblPos, layer: buttonLayer)
        
        setDifficultyUI()
        
    }
    
    func setDifficultyUI() {
        let difficultySelectorSize = CGSize(width: easyLabel.frame.width + 5, height: easyLabel.frame.height + 5)
        selectedDifficultyLabel = SKSpriteNode(color: UIColor.black, size: difficultySelectorSize)
        selectedDifficultyLabel.position = easyLabel.position
        self.addChild(selectedDifficultyLabel)
    }
    
    func configureLabelNode(node: SKLabelNode, text: String, position: CGPoint, layer: SKNode) {
        node.text = text
        node.fontSize = size.width / 10
        node.fontName = "AvenirNext-Bold"
        node.position = position
        node.verticalAlignmentMode = .center
        node.zPosition = 10
        layer.addChild(node)
    }
    
    // MARK: - touch functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: buttonLayer)
        let touchedNode = buttonLayer.nodes(at: location!).first
        
        if touchedNode == playLabel {            
            let scene = GameScene(size: self.size, difficulty: difficulty)
            scene.interstitialDelegate = viewController
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
    
    // MARK: - Feature
    func setDifficulty(node: SKNode) {
        switch node {
        case easyLabel:
            difficulty = Difficulty.easy
            selectedDifficultyLabel.position = easyLabel.position
            selectedDifficultyLabel.size = CGSize(width: easyLabel.frame.width + 10, height: easyLabel.frame.height + 10)
        
        case hardLabel:
            difficulty = Difficulty.hard
            selectedDifficultyLabel.position = hardLabel.position
            selectedDifficultyLabel.size = CGSize(width: hardLabel.frame.width + 10, height: hardLabel.frame.height + 10)
        default: break
        }        
    }
    


}
