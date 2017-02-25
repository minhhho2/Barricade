//
//  Background.swift
//  Barricade
//
//  Created by Minh Nguyen on 24/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class Background {
    
    static func addLayerBG(size: CGSize, bgLayer: SKNode) {
        let numRow = size.height / 50
        let numCol = size.width / 50
        let w = size.width / numCol
        let h = size.height / numRow
        
        for row in 0...Int(numRow) {
            for col in 0...Int(numCol) {
                let node = SKSpriteNode(imageNamed: "Tile")
                node.size = CGSize(width: w, height: h)
                node.position = CGPoint(x: CGFloat(col) * w - size.width / 2,
                                        y: CGFloat(row) * h - size.height / 2)
                node.zPosition = LayerZPos.menuBackgroundLayerZ - 1
                
                bgLayer.addChild(node)
            }
        }
    }
    
    static func addNodeFrame(nodeLayer: SKNode, frameLayer: SKNode) {
        for node in nodeLayer.children {
            let bgSize = CGSize(width: node.frame.width + 10, height: node.frame.height + 10)
            let nodeBG = SKSpriteNode(color: UIColor.black, size: bgSize)
            nodeBG.position = node.position
            nodeBG.zPosition = LayerZPos.menuBackgroundLayerZ + 1
            frameLayer.addChild(nodeBG)
            
        }
    }}
