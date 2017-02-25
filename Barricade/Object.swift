//
//  Object.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

class Object: Hashable {
    private var col: Int
    private var row: Int
    private let spriteName: String
    private var sprite: SKSpriteNode?
    
    var hashValue: Int {
        return row * 10 + col
    }
    
    init(col: Int, row: Int, imageName: String) {
        assert(col >= 0 && col < Game.numCols)
        assert(row >= 0 && row < Game.numRows)
        self.col = col
        self.row = row
        self.spriteName = imageName
    
    }
    
    // MARK: - Getters
    
    func getSpriteName() -> String {
        return self.spriteName
    }
    
    func getSprite() -> SKSpriteNode {
        return self.sprite!
    }
    
    func getCol() -> Int {
        return self.col
    }
    
    func getRow() -> Int {
        return self.row
    }
    
    // MARK: - Setters
    
    func setSprite(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
    
    func setColRow(newCol: Int, newRow: Int) {
        assert(newCol >= 0 && newCol < Game.numCols)
        assert(newRow >= 0 && newRow < Game.numRows)
        self.row = newRow
        self.col = newCol
    }
    
    /* Comparison function for hashable protocol */
    static func ==(lhs: Object, rhs: Object) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row 
    }
    
    /* Called upon freeing resources and removing instance */
    deinit {
        print("Freed \(spriteName) at (\(col),\(row))")
    }
    
}
