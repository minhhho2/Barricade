//
//  Level.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation

class Level {
    private var stage: Int
    
    /* Array for tile background */
    var tiles = Array2D<Tile>(cols: Game.numCols, rows: Game.numRows)
    
    /* Array for objects (player, monster, blocks) */
    fileprivate var board = Array2D<Object>(cols: Game.numCols, rows: Game.numRows)
    
    /* Array for collection of enemies on board */
    var enemies: Array<Enemy> = []
    
    init(stage: Int ) {
        self.stage = stage
        /* Initialize all elements in 'tiles' to a tile */
        for row in 0..<Game.numRows {
            for col in 0..<Game.numCols {
                tiles[col, row] = Tile() // IS THIS RIGHT
            }
        }
    }
    
    // MARK: - Return tile and object at position
    func objectAt(col: Int, row: Int) -> Object? {
        assert(col >= 0 && col < Game.numCols)
        assert(row >= 0 && row < Game.numRows)
        return board[col, row]
    }
    
    func tileAt(col: Int, row: Int) -> Tile? {
        assert(col >= 0 && col < Game.numCols)
        assert(row >= 0 && row < Game.numRows)
        return tiles[col, row]
    }
    
    // MARK: - Fill object layer
    
    func shuffle() -> Set<Object> {
        return createInitialObjects()
    }
    
    private func createInitialObjects() -> Set<Object> {
        var set = Set<Object>()

        /* Add Player */

        board[Player.sharedIntance.getCol(), Player.sharedIntance.getRow()] = Player.sharedIntance
        set.insert(Player.sharedIntance)
        
        /* Add Blocks */
        for row in 0..<Game.numRows {
            for col in 0..<Game.numCols {
                // Condition of spawning block
                if objectAt(col: col, row: row) == nil && col / 3 * 3 == col {
                //if objectAt(col: col, row: row) == nil && col / 2 * 2 != col && row / 2 * 2 != row {
                    let block = Block(col: col, row: row)
                    board[col, row] = block
                    set.insert(block)
                }
            }
        }
        
        /* Add Enemy - 1 per stage */
        for _ in 0..<self.stage {
            let newEnemy = spawnNewEnemy()
            set.insert(newEnemy)
        }
        return set
    }
    
    
    func spawnNewEnemy() -> Enemy {
        /* Find available positions */
        let playerCol = Player.sharedIntance.getCol()
        let playerRow = Player.sharedIntance.getRow()
        
        var emptyPositions: Array<BoardPosition> = []
        for row in 0..<Game.numRows {
            for col in 0..<Game.numCols {
                let colGapEnemyPlayer = abs(col + Game.numCols - (playerCol + Game.numCols))
                let rowGapEnemyPlayer = abs(row + Game.numRows - (playerRow + Game.numRows))
                if objectAt(col: col, row: row) == nil && (colGapEnemyPlayer > Constraint.colGap || rowGapEnemyPlayer > Constraint.rowGap) {
                    emptyPositions.append(BoardPosition(col: col, row: row))
                }
            }
        }
        
        /* Get random position */
        let numEmptyPositions = emptyPositions.count
        let randomPositionIndex = Int(arc4random_uniform(UInt32(numEmptyPositions)))
        let newPosition = emptyPositions[randomPositionIndex]
        
        /* Create enemy and add to array and board */
        let enemy = Enemy(col: newPosition.col, row: newPosition.row)
        board[newPosition.col, newPosition.row] = enemy
        enemies.append(enemy)
        return enemy
    }
 
    
    
    // MARK: - Functions
    
    /* Updates the board array for player and enemy moves */
    func updateArrayWithMove(objectA: Object, objectB: Object?, newObjectAPos: (col: Int, row: Int)? = nil  ) {
        /* condition for player/enemy moving */
        if objectB == nil && newObjectAPos != nil {
            board[newObjectAPos!.col, newObjectAPos!.row] = objectA
            board[objectA.getCol(), objectA.getRow()] = nil
            objectA.setColRow(newCol: newObjectAPos!.col, newRow: newObjectAPos!.row)
            return
        }
        
        /* condition for player pushing */
        if objectB != nil && newObjectAPos == nil {
            let newBlockPos = getNewBlockPos(player: objectA, block: objectB!)
            board[newBlockPos.col, newBlockPos.row] = objectB     // new block
            board[objectB!.getCol(), objectB!.getRow()] = objectA  // new beaver
            board[objectA.getCol(), objectA.getRow()] = nil         // old beaver

            // update beaver and block (c, r)
            objectA.setColRow(newCol: objectB!.getCol(), newRow: objectB!.getRow())
            objectB!.setColRow(newCol: newBlockPos.col, newRow: newBlockPos.row)
            return
        }
        assert(true, "Wrong combination of arguments given")
    }
    
    func removeFromBoard(col: Int, row: Int) {
        board[col, row] = nil

    }
    
    func checkEnemyAtPointHasOpening(col: Int, row: Int, enemies: Set<Enemy>) -> Bool {
        var currentChain = enemies
        currentChain.insert(objectAt(col: col, row: row) as! Enemy)
        var hasOpening = false
        
        /* Above */
        if row + 1 < Game.numRows {
            if objectAt(col: col, row: row + 1) == nil || objectAt(col: col, row: row + 1) is Player {
                return true
            }
            if objectAt(col: col, row: row + 1) is Enemy && !currentChain.contains(objectAt(col: col, row: row + 1) as! Enemy) {
                hasOpening = hasOpening || checkEnemyAtPointHasOpening(col: col, row: row + 1, enemies: currentChain)
            }
        }

        /* right */
        if col + 1 < Game.numCols {
            if objectAt(col: col + 1, row: row) == nil || objectAt(col: col + 1, row: row) is Player{
                return true
            }
            if objectAt(col: col + 1, row: row) is Enemy && !currentChain.contains(objectAt(col: col + 1, row: row) as! Enemy) {
                hasOpening = hasOpening || checkEnemyAtPointHasOpening(col: col + 1, row: row, enemies: currentChain)
            }
        }
        /* down */
        if row - 1 >= 0  {
            if objectAt(col: col, row: row - 1) == nil || objectAt(col: col, row: row - 1) is Player{
                return true
            }
            if objectAt(col: col, row: row - 1) is Enemy && !currentChain.contains(objectAt(col: col, row: row - 1) as! Enemy){
                hasOpening = hasOpening || checkEnemyAtPointHasOpening(col: col, row: row - 1, enemies: currentChain)
            }
        }
        /* left */
        if col - 1 >= 0 {
            if objectAt(col: col - 1, row: row) == nil || objectAt(col: col - 1, row: row) is Player{
                return true
            }
            if objectAt(col: col - 1, row: row) is Enemy && !currentChain.contains(objectAt(col: col - 1, row: row) as! Enemy) {
                hasOpening = hasOpening || checkEnemyAtPointHasOpening(col: col - 1, row: row, enemies: currentChain)
            }
        }
        return hasOpening

    }
    
    // MARK: - Function Helpers
    
    /* Checks if block can be pushed */
    func isBlockPushable(objectA: Object, objectB: Object) -> Bool {
        let newBlockPos = getNewBlockPos(player: objectA, block: objectB)
        
        if newBlockPos.col < 0 ||  newBlockPos.col >= Game.numCols ||
            newBlockPos.row < 0 || newBlockPos.row >= Game.numRows {
            return false
        }
        
        if objectAt(col: newBlockPos.col, row: newBlockPos.row) != nil {
            return false
        }
        return true
    }
    
    /* Returns the  (c, r) infront of the block based on the position of the player */
    func getNewBlockPos(player: Object, block: Object) -> BoardPosition {
        let newCol = block.getCol() + (block.getCol() - player.getCol())
        let newRow = block.getRow() + (block.getRow() - player.getRow())
        return BoardPosition(col: newCol, row: newRow)
    }
    
    func isObjectNilAt(col: Int, row: Int) -> Bool {
        return objectAt(col: col, row: row) == nil
    }

    func nextStage() {
        self.stage += 1
    }
    
    func getStage() -> Int {
        return self.stage
    }
}
