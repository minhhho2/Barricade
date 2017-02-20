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

    init(arrSize: CGSize, xRight: CGFloat, yBot: CGFloat, layer: SKNode) {
        let upPos = CGPoint(x: xRight - 1.75 * arrSize.width, y: yBot + 2.5 * arrSize.height)
        let downPos = CGPoint(x: xRight - 1.75 * arrSize.width, y: yBot + 0.5 * arrSize.height)
        let leftPos = CGPoint(x: xRight - 3 * arrSize.width, y: yBot + 1.5 * arrSize.height)
        let rightPos = CGPoint(x: xRight - arrSize.width / 2, y: yBot + 1.5 * arrSize.height)
        
        let upArr = TouchableNode(name: "Up", imageName: "UpArrow", position: upPos, size: arrSize, alpha: 0.2, layer: layer)
        let downArr = TouchableNode(name: "Down", imageName: "DownArrow", position: downPos, size: arrSize, alpha: 0.2, layer: layer)
        let leftArr = TouchableNode(name: "Left", imageName: "LeftArrow", position: leftPos, size: arrSize, alpha: 0.2, layer: layer)
        let rightArr = TouchableNode(name: "Right", imageName: "RightArrow", position: rightPos, size: arrSize, alpha: 0.2, layer: layer)
        
        arrows = [upArr.node, downArr.node, leftArr.node, rightArr.node]
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
