//
//  TouchableNode.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 20/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class TouchableNode {
    
    var node = SKSpriteNode()

    init(imageName: String, position: CGPoint, size: CGSize, alpha: CGFloat, layer: SKNode) {
        node.texture = SKTexture(imageNamed: imageName)
        node.position = position
        node.zPosition = LayerZPos.touchableLayerZ
        node.size = size
        node.alpha = alpha
        layer.addChild(node)
        
    }
}
