//
//  Helper.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction: String {
    case none = "None", up = "Up", down = "Down", left = "Left", right = "Right"
}

struct Constants {
    /* Initial Sprites */
    static let playerSprite: String = "PlayerDown"
    static let CROC_SRITE: String = "Croc"
    static let BLOCK_SPRITE: String = "Block"
    
}

struct Game {
    // Odd number for pretty board
    static let numRows: Int = 13
    static let numCols: Int = 13 // HAS TO BE BIGGER THAN GAP
    static let initialStage: Int = 1
}

struct Constraint {
    static let colGap = 3
    static let rowGap = 3
}

struct AnimationTime {
    static let player = 0.25
    static let block = 0.25
    static var enemy = 0.5
}

/* Tuple that represents the column and row on the board */
struct BoardPosition {
    let col: Int
    let row: Int
}

struct Difficulty {
    static let easy: TimeInterval = 1.0
    static let med: TimeInterval = 0.75
    static let hard: TimeInterval = 0.50
}




/*
 /* Resume game with count down */
 let resumeTimer = SKSpriteNode()
 resumeTimer.zPosition = 4
 resumeTimer.size = CGSize(width: 100, height: 100)
 self.addChild(resumeTimer)
 
 let arrayCountDownTexture = [
 SKTexture(imageNamed: "NumberThree"),
 SKTexture(imageNamed: "NumberTwo"),
 SKTexture(imageNamed: "NumberOne")]
 
 let animteCountDown = SKAction.animate(with: arrayCountDownTexture, timePerFrame: 1)
 let removeResumeNode = SKAction.removeFromParent()
 let resumeSequence = SKAction.sequence([animteCountDown, removeResumeNode])
 resumeTimer.run(resumeSequence)
 */




