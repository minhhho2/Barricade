//
//  Player.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 11/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class Player: Monster {
    
    /* Statistics */
    static let sharedIntance = Player(col: 0, row: 0)

    private init(col: Int, row: Int) {
        super.init(col: col, row: row, imageName: ImageName.playerStart)
    }
    
    func resetColRow() {
        self.setColRow(newCol: 0, newRow: 0)
    }

    
}
