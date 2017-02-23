//
//  Enemy.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: Monster {
    
    var isAlive: Bool = true
    var lastDirection: Direction = Direction.down
    
    init(col: Int, row: Int) {
        super.init(col: col, row: row, imageName: ImageName.enemyStart)
    }
    

    
    
}
