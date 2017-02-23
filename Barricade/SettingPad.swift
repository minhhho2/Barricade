//
//  SettingPad.swift
//  Barricade
//
//  Created by Minh Nguyen on 23/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class SettingPad {
    init(arrSize: CGSize, xPos: CGFloat, yPos: CGFloat, layer: SKNode) {
        
        let size = CGSize(width: arrSize.width / 2, height: arrSize.height / 2)
        
        let soundPos = CGPoint(x: xPos + arrSize.width, y: yPos)
        
        _ = TouchableNode(name: "Mute", imageName: "Block", position: soundPos, size: size, alpha: 1.0, layer: layer)
        
        let downPos = CGPoint(x: xPos + 2 * arrSize.width, y: yPos)
        
        let upPos = CGPoint(x: xPos + 3 * arrSize.width, y: yPos)

        _ = TouchableNode(name: "Down Alpha", imageName: "Block", position: downPos, size: size, alpha: 1.0, layer: layer)

        _ = TouchableNode(name: "Up Alpha", imageName: "Block", position: upPos, size: size, alpha: 1.0, layer: layer)
    }
}
