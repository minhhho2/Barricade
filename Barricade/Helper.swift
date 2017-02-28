//
//  Helper.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import SpriteKit

/* Possible directions that in game entities game move */
enum Direction: String {
    case none = "None", up = "Up", down = "Down", left = "Left", right = "Right"
}

struct ImageName {
    /* Initial Sprites */
    static let playerStart: String = "PlayerDown"
    static let enemyStart: String = "EnemyDown"
    static let block: String = "Block"
}

struct Message {
    static let newGame = "TAP TO PLAY!"//"Tap To Play!"
    static let resumeGame = "TAP TO RESUME!"//"Tap To Resume!"
    static let restartLevel = "RESTART LEVEL! TAP TO PLAY!" //"Restart Level! Tap To Play!"
    static let nextLevel = "NEXT LEVEL! TAP TO PLAY"//"Next Level! Tap To Play!"
    static let exitGame = "EXIT GAME?"//"Exit Game?"
    static let gameOver = "GAME OVER!"//"Game Over!"
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
    static let hard: TimeInterval = 0.50
}

struct LayerZPos {
    static let gameLayerZ: CGFloat = 10
    static let tileLayerZ: CGFloat = 20
    static let objectLayerZ: CGFloat = 30
    static let gameBackgroundLayerZ: CGFloat = 35
    static let touchableLayerZ: CGFloat = 40
    static let menuLayerZ: CGFloat = 50
    static let pauseLayerZ: CGFloat = 50
    static let gameOverLayerZ: CGFloat = 50
    static let settingLayerZ: CGFloat = 50
    static let nextLevelLayerZ: CGFloat = 50
    
    
    static let menuBackgroundLayerZ: CGFloat = 10
    static let buttonLayerZ: CGFloat = 20
    static let instructionLayerZ: CGFloat = 30
}
