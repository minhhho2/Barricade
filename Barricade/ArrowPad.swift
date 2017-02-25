//
//  ArrowPad.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 20/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class ArrowPad {
    
    var arrows: Array<SKSpriteNode> = []
    var alpha: CGFloat = 0.4

    init(arrSize: CGSize, xRight: CGFloat, yBot: CGFloat, layer: SKNode, size: CGSize) {
        /*
        let upPos = CGPoint(x: xRight - 1.75 * arrSize.width, y: yBot + 2.5 * arrSize.height)
        let downPos = CGPoint(x: xRight - 1.75 * arrSize.width, y: yBot + 0.5 * arrSize.height)
        let leftPos = CGPoint(x: xRight - 3 * arrSize.width, y: yBot + 1.5 * arrSize.height)
        let rightPos = CGPoint(x: xRight - arrSize.width / 2, y: yBot + 1.5 * arrSize.height)
        */
        let yfallsDownBy = size.height / 2 - (arrSize.height * CGFloat(Game.numRows) / 2)

        
        let upPos = CGPoint(x: 0, y: 0 + size.height / 4 - yfallsDownBy)
        let downPos = CGPoint(x: 0, y: 0 - size.height / 4 - yfallsDownBy)
        let leftPos = CGPoint(x: -size.width / 4, y: 0 - yfallsDownBy)
        let rightPos = CGPoint(x: size.width / 4, y: 0 - yfallsDownBy)
        
        let sizeLeftRight = CGSize(width: arrSize.width * 4, height: arrSize.height * 2)
        
        let sizeUpDown = CGSize(width: arrSize.width * 2, height: arrSize.height * 4)
        

        
        let upArr = TouchableNode(name: "Up", imageName: "UpArrow", position: upPos, size: sizeUpDown, alpha: alpha, layer: layer)
        let downArr = TouchableNode(name: "Down", imageName: "DownArrow", position: downPos, size: sizeUpDown, alpha: alpha, layer: layer)
        let leftArr = TouchableNode(name: "Left", imageName: "LeftArrow", position: leftPos, size: sizeLeftRight, alpha: alpha, layer: layer)
        let rightArr = TouchableNode(name: "Right", imageName: "RightArrow", position: rightPos, size: sizeLeftRight, alpha: alpha, layer: layer)
        
        arrows = [upArr.node, downArr.node, leftArr.node, rightArr.node]
    }
    
    func getAlpha() -> CGFloat {
        return self.alpha
    }
    
    func increaseAlpha() {
        if alpha < 1 {
            alpha += 0.1
        }
    }
    
    func decreaseAlpha() {
        if alpha > 0.11 {
            alpha -= 0.1
        }
    }
    
    func containsNode(node: SKNode?) -> Bool {
        return arrows.contains(node! as! SKSpriteNode)        
    }
    
    func setAllArrowAlpha(to value: CGFloat) {
        for arrow in arrows {
            arrow.alpha = value
        }
    }
}
