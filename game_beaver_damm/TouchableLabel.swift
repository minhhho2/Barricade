//
//  TouchableLabel.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 18/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class TouchableLabel {
    
    var node = SKLabelNode()
    
    init(text: String, name: String, pos: CGPoint, layer: SKNode,
         fontName: String, fontSize: CGFloat,
         vertAlign: SKLabelVerticalAlignmentMode,
         horzAlign: SKLabelHorizontalAlignmentMode) {
        
        // Create and add label to layer
        node = SKLabelNode()
        node.text = text
        node.name = name
        node.position = pos
        node.zPosition = layer.zPosition + 1
        node.fontName = fontName
        node.fontSize = fontSize
        node.verticalAlignmentMode = vertAlign
        node.horizontalAlignmentMode = horzAlign
        layer.addChild(node)
    }

}
