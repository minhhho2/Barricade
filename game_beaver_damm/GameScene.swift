//
//  GameScene.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 11/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    var level: Level!
    
    /* Tile Size */
    let TileWidth: CGFloat
    let TileHeight: CGFloat
    
    /* Monster move configuration */
    var lastTime: TimeInterval = 0.0
    var moveRate : TimeInterval = 1.0
    var timeSinceMove: TimeInterval = 0.0

    /* Game Layers */
    let gameLayer = SKNode()
    let tileLayer = SKNode()
    let objectLayer = SKNode()
    let touchableLayer = SKNode()
    
    let pauseLayer = SKNode()
    let gameOverLayer = SKNode()
    
    /* Game Buttons and Text*/
    var menuLabel = SKLabelNode()
    var pauseLabel = SKLabelNode()
    var readyLabel: SKLabelNode? = SKLabelNode()
    
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    

    var upBtn = SKSpriteNode()
    var downBtn = SKSpriteNode()
    var leftBtn = SKSpriteNode()
    var rightBtn = SKSpriteNode()
    
    /* Game variables */
    var isGameOver: Bool = false
    var score: Int = 0
    var highScore: Int = 0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        TileWidth = (size.width * 1.0 ) / CGFloat(Game.numCols)
        TileHeight = (size.height * 0.8) / CGFloat(Game.numRows)
        
        print("New Game Scene")
        /* Configure and add background */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let background = SKSpriteNode(imageNamed: "GameBG")
        background.size = size
        self.addChild(background)
        
        /* Create and configure layers */
        let cornerBotLeftPoint = CGPoint(x: -TileWidth * CGFloat(Game.numCols) / 2, y: -TileHeight * CGFloat(Game.numRows) / 2)
        let centrePoint = CGPoint(x: 0, y: 0)
        configureLayer(parentLayer: self, childLayer: gameLayer, position: centrePoint, zPosition: 1)
        configureLayer(parentLayer: gameLayer, childLayer: tileLayer, position: cornerBotLeftPoint, zPosition: 2)
        configureLayer(parentLayer: gameLayer, childLayer: objectLayer, position: cornerBotLeftPoint, zPosition: 3)
        configureLayer(parentLayer: gameLayer, childLayer: touchableLayer, position: centrePoint, zPosition: 4)
        configureLayer(parentLayer: gameLayer, childLayer: pauseLayer, position: centrePoint, zPosition: 6)
        configureLayer(parentLayer: gameLayer, childLayer: gameOverLayer, position: centrePoint, zPosition: 6)
        pauseLayer.isHidden = true
        gameOverLayer.isHidden = true
    
        /* Create and configure score labels */
        let scorePos = CGPoint(x: 0, y: -self.size.height / 2)
        configureLabelNode(node: scoreLabel, text: "Score: \(score)", position: scorePos, layer: gameLayer)
        
        let highScorePos = CGPoint(x: 0, y: -self.size.height / 2 + scoreLabel.frame.height)
        configureLabelNode(node: highScoreLabel, text: "Score: \(highScore)", position: highScorePos, layer: gameLayer)
        
        /* Create and configure buttons and labels */
        let btnSize = CGSize(width: TileWidth * 2, height: TileHeight * 2)
        
        let pauseLblPos = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
        configureLabelNode(node: pauseLabel, text: "Pause", position: pauseLblPos, layer: touchableLayer)
        
        let menuLblPos = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2 + pauseLabel.frame.height)
        configureLabelNode(node: menuLabel, text: "Menu", position: menuLblPos, layer: touchableLayer)
        
        let readyLblPos = CGPoint(x: 0, y: 0)
        configureLabelNode(node:readyLabel!, text: "Press to play!", position: readyLblPos, layer: touchableLayer)
        
        let upBtnPos = CGPoint(x: self.size.width / 2 - 2.5 * btnSize.width / 2, y: -self.size.height / 2 + 3.5 * btnSize.height)
        configureSKSpriteNode(node: upBtn, imageName: "UpArrow", position: upBtnPos, zPosition: 4, size: btnSize, alpha: 1)

        let downBtnPos = CGPoint(x: self.size.width / 2 - 2.5 * btnSize.width / 2, y: -self.size.height / 2 + 1.5 * btnSize.height)
        configureSKSpriteNode(node: downBtn, imageName: "DownArrow", position: downBtnPos, zPosition: 4, size: btnSize, alpha: 1)

        let leftBtnPos = CGPoint(x: self.size.width / 2 - 4 * btnSize.width / 2, y: -self.size.height / 2 + 2.5 * btnSize.height)
        configureSKSpriteNode(node: leftBtn, imageName: "LeftArrow", position: leftBtnPos, zPosition: 4, size: btnSize, alpha: 1)

        let rightBtnPos = CGPoint(x: self.size.width / 2 - btnSize.width / 2, y: -self.size.height / 2 + 2.5 * btnSize.height)
        configureSKSpriteNode(node: rightBtn, imageName: "RightArrow", position: rightBtnPos, zPosition: 4, size: btnSize, alpha: 1)
        
        startNewGame()
 
        /* Pause game at the start to run ready text*/
        let pauseAction = SKAction.run {
            self.view?.isPaused = true
        }
        self.run(pauseAction)
    }
    func startNewGame() {
        objectLayer.removeAllChildren()
        tileLayer.removeAllChildren()
        gameOverLayer.removeAllChildren()
        
        Player.sharedIntance.resetColRow()
        level = Level()
        addTiles()
        beginGame()
    }

    func configureLayer(parentLayer: SKNode, childLayer: SKNode, position: CGPoint, zPosition: CGFloat) {
        childLayer.position = position
        childLayer.zPosition = zPosition
        parentLayer.addChild(childLayer)
    }
    
    func configureLabelNode(node: SKLabelNode, text: String, position: CGPoint, layer: SKNode) {
        node.text = text
        node.fontSize = size.width / 13
        node.position = position
        node.zPosition = 10
        node.horizontalAlignmentMode = .left
        node.verticalAlignmentMode = .bottom
        layer.addChild(node)
    }
    
    func configureSKSpriteNode(node: SKSpriteNode, imageName: String, position: CGPoint, zPosition: CGFloat, size: CGSize, alpha: CGFloat) {
        node.texture = SKTexture(imageNamed: imageName)
        node.position = position
        node.zPosition = zPosition
        node.size = size
        node.alpha = alpha
        touchableLayer.addChild(node)
    }
    
    // MARK: - Game Setup
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newObjects = level.shuffle()
        addSprites(for: newObjects)
    }
    
    func addTiles() {
        for row in 0..<Game.numRows {
            for col in 0..<Game.numCols {
                if level.tileAt(col: col, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(col: col, row: row)
                    tileLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func addSprites(for objects: Set<Object>) {
        for object in objects {
            // Create and configure sprite
            let sprite = SKSpriteNode(imageNamed: object.getSpriteName())
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(col: object.getCol(), row: object.getRow())
            
            // Add sprite to object and view
            object.setSprite(sprite: sprite)
            objectLayer.addChild(object.getSprite())
        }
    }
    

    // MARK: Load screen
    override func didMove(to view: SKView) {
        //Load Score
        let defaults: UserDefaults = UserDefaults.standard
        let score = defaults.value(forKey: "Score") ?? 0
        defaults.synchronize()
        self.score = score as! Int
        
        //Load Highscore
        let secondDefaults: UserDefaults = UserDefaults.standard
        let highscore = secondDefaults.value(forKey: "Highscore") ?? 0
        secondDefaults.synchronize()
        self.highScore = highscore as! Int
        
        //Set Score Text
        scoreLabel.text = "Score: \(score)"
        highScoreLabel.text = "High Score: \(highScore)"

    }

    
    // MARK: - Contact functions
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: touchableLayer)
        let touchedNode = self.nodes(at: location).first // first is layer itself

        print("Touch at  \(location.x) - \(location.y) with count:  \(self.nodes(at: location).count)")

        let isGamePaused = self.view?.isPaused
        
        if isGamePaused! && readyLabel != nil {
            handleFirstTouchReadyText()
            return
        }
        
        if !pauseLayer.isHidden {
            handleTouchWithDisplayedPauseLayer(touchedNode: touchedNode)
            return
        }
        
        if touchedNode == menuLabel {
            handleTouchOnMenu()
            return
        }
        
        /* Pause game */
        if touchedNode == pauseLabel {
            handleTouchOnPauseWithUnPausedGame()
            return
 
        }
        
        if isGameOver {
            handleGameOver()
        }
        
        /* Player Move */
        if !(isGamePaused)! && !isGameOver && touchedNode != nil {
            let newPlayerDirection = getDirectionOfTouch(node: touchedNode!)
            self.handleMove(direction: newPlayerDirection)
            return
        }
    }
    // MARK: - Handle touch functions

    func handleFirstTouchReadyText() {
        readyLabel?.removeFromParent()
        readyLabel = nil
        self.view?.isPaused = false
    }
    
    func handleTouchOnMenu() {
        Player.sharedIntance.resetColRow()
        let scene: SKScene = MenuScene(size: self.size)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }
    
    
    func handleTouchWithDisplayedPauseLayer(touchedNode: SKNode?) {
        pauseLayer.isHidden = true
        self.view?.isPaused = false
        pauseLayer.removeAllChildren()
    }
    
    func handleTouchOnPauseWithUnPausedGame() {
        let pauseBG = SKSpriteNode(imageNamed: "MenuBG")
        pauseBG.zPosition = 6
        pauseBG.size = self.size
        pauseBG.position = CGPoint(x: 0, y: 0)
        pauseLayer.addChild(pauseBG)

        let resumeGame = SKLabelNode(text: "Press to Resume")
        resumeGame.horizontalAlignmentMode = .center
        resumeGame.zPosition = 6
        pauseLayer.addChild(resumeGame)
        pauseLayer.isHidden = false
        
        let changeImage = SKAction.run {
            self.view?.isPaused = true
            
        }
        self.run(changeImage)
    }

    // MARK: - End of turn
    func checkEnemyCanMove(_ frameRate: TimeInterval) {
        timeSinceMove += frameRate
        
        if timeSinceMove < moveRate {
            return
        }
        moveEnemy()
        timeSinceMove = 0.0
        
    }
    
    func moveEnemy() {
        for enemy in level.enemies {
            var enemyMoves = computePossibleEnemyMoves(enemy: enemy)
            if enemyMoves.count <= 0 {
                continue
            }

            let moveIndex = Int(arc4random_uniform(UInt32(enemyMoves.count)))
            let nextMove = enemyMoves[moveIndex]
            let position = getNewPositionFromDirection(col: enemy.getCol(), row: enemy.getRow(), direction: nextMove)
            enemy.lastDirection = nextMove
            
            if level.objectAt(col: position.col, row: position.row) is Player {
                isGameOver = true
            } else {
                animateMove(newCol: position.col, newRow: position.row, objectA: enemy, block: nil)
                level.updateArrayWithMove(objectA: enemy, objectB: nil, newObjectAPos: (position.col, position.row))
            }
        }
    }
    
    /* Called before each frame is rendered */
    override func update(_ currentTime: TimeInterval) {
        let gameIsPaused = self.view?.isPaused
        if !gameIsPaused! {
            if !isGameOver {
                checkEnemyCanMove(currentTime - lastTime)
                lastTime = currentTime
                updateEnemyStates()
            }
        }
        updateHighScore()
        
    }
    
    func updateHighScore() {
        if score > highScore {
            highScore = score
            let secondDefaults: UserDefaults = UserDefaults.standard
            secondDefaults.set(highScore, forKey: "Highscore")
            secondDefaults.synchronize()
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    
    func addScore() {
        self.score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateEnemyStates() {
        /* Compute current enemy states */
        let chain: Set<Enemy> = []
        for enemy in level.enemies {
            enemy.isAlive = level.checkEnemyAtPointHasOpening(col: enemy.getCol(), row: enemy.getRow(), enemies: chain)
        }
        
        /* Add all dead enemies to list */
        var deadEnemies: Set<Enemy> = []
        for enemy in level.enemies {
            if !enemy.isAlive {
                deadEnemies.insert(enemy)
                addScore()
            }
        }

        /* Remove dead enemies and spawn new ones */
        for enemy in deadEnemies {
            // remove from array and board and screen
            let index = level.enemies.index(of: enemy)
            level.enemies.remove(at: index!)
            level.removeFromBoard(col: enemy.getCol(), row: enemy.getRow())
            objectLayer.removeChildren(in: [enemy.getSprite() as SKNode])
            
            // add to array and screen
            let newEnemies: Set<Enemy> = [level.spawnNewEnemy(), level.spawnNewEnemy()]
            addSprites(for: newEnemies)
        }
    }
    
    func handleGameOver() {
        gameOverLayer.isHidden = false
        
        let gameOverLabel = SKLabelNode()
        configureLabelNode(node: gameOverLabel, text: "Game Over!", position: CGPoint(x: 0, y: 0), layer: gameOverLayer)
        
        let scoreLabel = SKLabelNode()
        configureLabelNode(node: scoreLabel, text: "Score: \(score)", position: CGPoint(x: 0, y: -gameOverLabel.frame.height), layer: gameOverLayer)

        let highScoreLabel = SKLabelNode()
        configureLabelNode(node: highScoreLabel, text: "High Score: \(highScore)", position: CGPoint(x: 0, y: -gameOverLabel.frame.height * 3), layer: gameOverLayer)
        
        let newGameLabel = SKLabelNode()
        configureLabelNode(node: newGameLabel, text: "Start New Game", position: CGPoint(x: 0, y: -gameOverLabel.frame.height * 5), layer: gameOverLayer)

        let restartLevelLabel = SKLabelNode()
        configureLabelNode(node: restartLevelLabel, text: "Restart Level", position: CGPoint(x: 0, y: -gameOverLabel.frame.height * 7), layer: gameOverLayer)
    }
    
    // MARK: - Handle Button Touch
    
    func handleMove(direction: Direction) {
        let position = getNewPositionFromDirection(col: Player.sharedIntance.getCol(),
                row: Player.sharedIntance.getRow(), direction: direction)

        if position.col < 0 || position.col >= Game.numCols || position.row < 0 || position.row >= Game.numRows { // Out of bounds
            return
        }
        
        let objectAtNewPos: Object? = level.objectAt(col: position.col, row: position.row)
        
        if objectAtNewPos == nil { // Try moving beaver
            animateMove(newCol: position.col, newRow: position.row, objectA: Player.sharedIntance, block: nil)
            level.updateArrayWithMove(objectA: Player.sharedIntance, objectB: nil, newObjectAPos: (position.col, position.row))
            
        } else if objectAtNewPos is Block { // Try pushing block
            if level.isBlockPushable(objectA: Player.sharedIntance, objectB: objectAtNewPos!) == false {
                return
            }
            animateMove(newCol: position.col, newRow: position.row, objectA: Player.sharedIntance, block: objectAtNewPos!)
            level.updateArrayWithMove(objectA: Player.sharedIntance, objectB: objectAtNewPos!)
            
        } else if objectAtNewPos is Enemy { // Cant push croc
            return
        }
    }
    
    
    /* Animate move for beaver and block */
    func animateMove(newCol: Int, newRow: Int, objectA: Object?, block: Object?) {
        let spriteA = objectA!.getSprite()
        let durationA: TimeInterval = (objectA! is Player) ? AnimationTime.player : AnimationTime.enemy
        let newPointA = pointFor(col: newCol, row: newRow)
        let moveA = SKAction.move(to: newPointA, duration: durationA)
        moveA.timingMode = .easeOut
        spriteA.run(moveA)
        
        if objectA == nil || block == nil {
            return
        }
        let newBlockPos = level.getNewBlockPos(player: objectA!, block: block!)
        let newBlockPoint = pointFor(col: newBlockPos.col, row: newBlockPos.row)
        
        let spriteB = block!.getSprite()
        let durationBlock: TimeInterval = AnimationTime.block
        let moveB = SKAction.move(to: newBlockPoint, duration: durationBlock)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }
    
    // MARK: - Function helpers
    func getDirectionOfTouch(node: SKNode) -> Direction {
        switch node {
        case upBtn: return Direction.up
        case downBtn: return Direction.down
        case leftBtn: return Direction.left
        case rightBtn: return Direction.right
        default: return Direction.none
        }

    }
    
    /* Convert (col, row) to point */
    func pointFor(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(col) * TileWidth + TileWidth / 2, y: CGFloat(row) * TileHeight + TileHeight / 2)
    }
    
    /* Convert point to (col, row) */
    func convertPoint(point: CGPoint) -> (success: Bool, col: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(Game.numCols) * TileWidth && point.y >= 0 && point.y < CGFloat(Game.numRows) * TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)
        }
    }
    
    /* Check if a monster can move */
    func isMovable(_ monster: Enemy) -> Bool {
        let col: Int = monster.getCol()
        let row: Int = monster.getRow()
        
        return (
            (row + 1 < Game.numRows && level.objectAt(col: col, row: row + 1) == nil) ||
            (col + 1 < Game.numCols && level.objectAt(col: col + 1, row: row) == nil) ||
            (row - 1 >= 0 && level.objectAt(col: col, row: row - 1) == nil) ||
            (col - 1 >= 0 && level.objectAt(col: col - 1, row: row) == nil)
        )
    }
    
    func getNewPositionFromDirection(col: Int, row: Int, direction: Direction) -> BoardPosition {
        var col = col
        var row = row
        
        switch direction {
        case .up: row += 1
        case .right: col += 1
        case .down: row -= 1
        case .left: col -= 1
        case .none: break
        }
        
        return BoardPosition(col: col, row: row)
    }
    
    /* Returns the direction in the opposite direction of the given direction */
    func getOppositeDirection(direction: Direction) -> Direction {
        var oppositeDirection: Direction
        
        switch direction {
        case .up: oppositeDirection = Direction.down
        case .down: oppositeDirection = Direction.up
        case .left: oppositeDirection = Direction.right
        case .right: oppositeDirection = Direction.left
        case .none: oppositeDirection = Direction.none
        }
        
        return oppositeDirection
    }
    
    /* Function that determines where an enemy can move */
    func computePossibleEnemyMoves(enemy: Enemy) -> Array<Direction> {
        var possibleMoves: Array<Direction> = []
        let curCol: Int = enemy.getCol()
        let curRow: Int = enemy.getRow()
        
        if curRow + 1 < Game.numRows && (level.objectAt(col: curCol, row: curRow + 1) == nil ||
                level.objectAt(col: curCol, row: curRow + 1) is Player) {
            possibleMoves.append(Direction.up)
        }
        
        if  curRow - 1 >= 0 && (level.objectAt(col: curCol, row: curRow - 1) == nil ||
                level.objectAt(col: curCol, row: curRow - 1) is Player) {
            possibleMoves.append(Direction.down)
        }
        
        if curCol - 1 >= 0 && (level.objectAt(col: curCol - 1, row: curRow) == nil ||
                level.objectAt(col: curCol - 1, row: curRow) is Player) {
            possibleMoves.append(Direction.left)
        }
        
        if curCol + 1 < Game.numCols && (level.objectAt(col: curCol + 1, row: curRow) == nil ||
                level.objectAt(col: curCol + 1, row: curRow) is Player) {
            possibleMoves.append(Direction.right)
        }
        
        let oppositeDirection = getOppositeDirection(direction: enemy.lastDirection)
        if possibleMoves.count > 1 && possibleMoves.contains(oppositeDirection) {
            let index = possibleMoves.index(of: oppositeDirection)
            possibleMoves.remove(at: index!)
        }
        
        return  possibleMoves
    }

}



