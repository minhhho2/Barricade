//
//  Instruction.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 18/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class Instruction {
    
    var instructFilenames: Array<String> = []
    var insturctSize: Array<CGFloat> = []
    var imageNamePrefix: String = "Instruction_"
    var currentImageIndex: Int = 0
    
    var instruct1 = SKLabelNode()
    
    var currentImageNode = SKSpriteNode()
    
    init(size: CGSize) {
        // Add instruction file names
        for i in 0..<5 {
            let imageName = "\(imageNamePrefix)\(i)"
            print(imageName)
            instructFilenames.append(imageName)
        }
                
        // create node for instructions
        let firstInstructTexture = SKTexture(imageNamed: instructFilenames[0])
        currentImageNode = SKSpriteNode(texture: firstInstructTexture)
        
        currentImageNode.size = CGSize(width: size.width / 1.5, height: size.height / 1.5)
        currentImageNode.position = CGPoint(x: 0, y: 0)
        currentImageNode.zPosition = LayerZPos.instructionLayerZ
        currentImageNode.name = "CurrentImage"
        
        instruct1.fontSize = size.width / 15
        
        
        
    }
    
    func setNextTexture() {
        if currentImageIndex < instructFilenames.count - 1 {
            self.currentImageIndex += 1
        }
        currentImageNode.texture = SKTexture(imageNamed: instructFilenames[currentImageIndex])
    }
    
    func setPrevTexture() {
        if currentImageIndex > 0 {
            self.currentImageIndex -= 1
        }
        currentImageNode.texture = SKTexture(imageNamed: instructFilenames[currentImageIndex])
    }
}
