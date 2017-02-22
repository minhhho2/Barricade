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
    var imageNamePrefix: String = "Instruction_"
    var currentImageIndex: Int = 0
    
    var currentImageNode = SKSpriteNode()
    
    init() {
        // Add instruction file names
        for i in 0..<3 {
            let imageName = "\(imageNamePrefix)\(i)"
            print(imageName)
            instructFilenames.append(imageName)
        }
        
        // create node for instructions
        let firstInstructTexture = SKTexture(imageNamed: instructFilenames[0])
        currentImageNode = SKSpriteNode(texture: firstInstructTexture)
        currentImageNode.size = CGSize(width: 75, height: 75)
        currentImageNode.position = CGPoint(x: 0, y: 0)
        currentImageNode.zPosition = 20
        currentImageNode.name = "CurrentImage"
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
