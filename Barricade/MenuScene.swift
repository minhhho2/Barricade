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
import AVFoundation

class MenuScene: SKScene {
    var viewController: GameViewController!
    var bannerView: GADBannerView!
    
    var selectedDifficultyLabel = SKSpriteNode()
    
    /* Layer */
    var buttonLayer = SKNode()
    var instructionLayer = SKNode()
    var backgroundLayer = SKNode()
    
    /* Data */
    var difficulty: TimeInterval = Difficulty.easy
    var difficultyOptions: Array<SKNode> = []
    var instructions: Instruction?
    var isMute: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        /* Configure and add background */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        buttonLayer.zPosition = LayerZPos.buttonLayerZ
        self.addChild(buttonLayer)

        instructionLayer.zPosition = LayerZPos.instructionLayerZ
        self.addChild(instructionLayer)
        instructionLayer.isHidden = true
        
        backgroundLayer.zPosition = LayerZPos.menuBackgroundLayerZ
        self.addChild(backgroundLayer)
        
        
        let easyLblPos = CGPoint(x: -self.frame.width / 4, y: 0)
        let easyLabel = TouchableLabel(text: "EASY", name: "Easy", pos: easyLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        let hardLblPos = CGPoint(x: self.frame.width / 4, y: 0)
        let hardLabel = TouchableLabel(text: "HARD", name: "Hard", pos: hardLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        difficultyOptions = [easyLabel.node, hardLabel.node]

        let labelHeight = easyLabel.node.frame.height
        
        let playLblPos = CGPoint(x: 0, y: 0 + labelHeight * 3)
        _ = TouchableLabel(text: "PLAY", name: "Play", pos: playLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)

        let instructLblPos = CGPoint(x: 0, y: 0 - labelHeight * 3)
        _ = TouchableLabel(text: "INSTRUCTION", name: "Instruction", pos: instructLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)

        addMenuSceneBG()
        addEasyHardNodeFrame()
        
        setDifficultyUI()
    }
    
    
    
    func setDifficultyUI() {
        let easyLabel = buttonLayer.childNode(withName: "Easy")!
        let difficultySelectorSize = CGSize(width: easyLabel.frame.width + 10,height: easyLabel.frame.height + 10)
        selectedDifficultyLabel = SKSpriteNode(color: UIColor.gray, size: difficultySelectorSize)
        selectedDifficultyLabel.position = easyLabel.position
        selectedDifficultyLabel.zPosition = LayerZPos.menuBackgroundLayerZ + 2
        backgroundLayer.addChild(selectedDifficultyLabel)
    }
    
    // MARK: - touch functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: buttonLayer)
        let touchedNode = buttonLayer.nodes(at: location).first
        
        if !instructionLayer.isHidden {
            handleTouchOnInstructLayer(touches: touches)
            return
        }
        
        if touchedNode == buttonLayer.childNode(withName: "Play") {
            handleTouchOnPlay()
            return
        }
        
        if touchedNode != nil && difficultyOptions.contains(touchedNode!) {
            handleTouchOnDifficulty(node: touchedNode!)
            return
        }
        if touchedNode == buttonLayer.childNode(withName: "Instruction") {
            handleTouchOnInstruct()
            return
        }
    }
    
    // MARK: - Touch
    func handleTouchOnPlay() {
        Music.playSound(scene: self, sound: Sounds.click)
        let scene = GameScene(size: self.size, difficulty: difficulty)
        scene.interstitialDelegate = viewController
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }
    
    func handleTouchOnInstruct() {
        Music.playSound(scene: self, sound: Sounds.click)
        instructions = Instruction(size: size)
        instructionLayer.isHidden = false
        addLayerBackground(layer: instructionLayer, zPos: LayerZPos.instructionLayerZ)
        instructionLayer.addChild((instructions?.currentImageNode)!)

        let prevLblPos = CGPoint(x: -self.size.width / 3, y: -self.size.height / 2.25)
        let nextLblPos = CGPoint(x: self.size.width / 3, y: -self.size.height / 2.25)
        let exitLblPos = CGPoint(x: 0, y: -self.size.height / 2.25)
        
        _ = TouchableLabel(text: "PREV", name: "Prev", pos: prevLblPos, layer: instructionLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)

        _ = TouchableLabel(text: "NEXT", name: "Next", pos: nextLblPos, layer: instructionLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        _ = TouchableLabel(text: "EXIT", name: "Exit", pos: exitLblPos, layer: instructionLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
    }
    
    func handleTouchOnInstructLayer(touches: Set<UITouch>) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: instructionLayer)
        let touchedNode = instructionLayer.nodes(at: location).first
        
        if touchedNode == instructionLayer.childNode(withName: "Prev") {
            Music.playSound(scene: self, sound: Sounds.click)
            instructions?.setPrevTexture()
        }
        if touchedNode == instructionLayer.childNode(withName: "Next") {
            Music.playSound(scene: self, sound: Sounds.click)
            instructions?.setNextTexture()
        }
        
        if touchedNode == instructionLayer.childNode(withName: "Exit") {
            Music.playSound(scene: self, sound: Sounds.click)
            instructions = nil
            instructionLayer.removeAllChildren()
            instructionLayer.isHidden = true
        }
    }
    
    // MARK: - Feature
    func handleTouchOnDifficulty(node: SKNode) {
        Music.playSound(scene: self, sound: Sounds.click)
        let easyLabel = buttonLayer.childNode(withName: "Easy")!
        let hardLabel = buttonLayer.childNode(withName: "Hard")!

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
    
    override func didMove(to view: SKView) {
        Music.preloadSounds()
    }

    func addLayerBackground(layer: SKNode, zPos: CGFloat) {
        let bg = SKSpriteNode(color: UIColor.darkGray, size: self.size)
        bg.zPosition = zPos - 1
        bg.position = CGPoint(x: 0, y: 0)
        layer.addChild(bg)
    }
    
    func addMenuSceneBG() {
        let numRow = self.size.height / 50
        let numCol = self.size.width / 50
        let w = self.size.width / numCol
        let h = self.size.height / numRow
        
        for row in 0...Int(numRow) {
            for col in 0...Int(numCol) {
                let node = SKSpriteNode(imageNamed: "Tile")
                node.size = CGSize(width: w, height: h)
                node.position = CGPoint(x: CGFloat(col) * w - size.width / 2,
                                        y: CGFloat(row) * h - size.height / 2)
                node.zPosition = LayerZPos.menuBackgroundLayerZ - 1
                backgroundLayer.addChild(node)
            }
        }
    }
    
    func addEasyHardNodeFrame() {
        for node in buttonLayer.children {
            let bgSize = CGSize(width: node.frame.width + 10, height: node.frame.height + 10)
            let nodeBG = SKSpriteNode(color: UIColor.black, size: bgSize)
            nodeBG.position = node.position
            nodeBG.zPosition = LayerZPos.menuBackgroundLayerZ + 1
            backgroundLayer.addChild(nodeBG)
        }
    }
}
