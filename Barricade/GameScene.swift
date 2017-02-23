//
//  GameScene.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 11/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

protocol InterstitialDelegate {
    func showInterstitialAd()
}

class GameScene: SKScene {
    var viewController: GameViewController!
    
    var interstitialDelegate: InterstitialDelegate?
    
    // MARK: - Subviews
    let gameLayer = SKNode()
    let tileLayer = SKNode()
    let objectLayer = SKNode()
    let touchableLayer = SKNode()
    
    let menuLayer = SKNode()
    let pauseLayer = SKNode()
    let gameOverLayer = SKNode()

    // MARK: - UI
    var arrowPad: ArrowPad?
    var settingPad: SettingPad?
    
    /* Game variables */
    var isGameOver: Bool = false
    var isMute: Bool = false
    var score: Int = 0
    var highScore: Int = 0
    var level: Level!

    let TileWidth: CGFloat
    let TileHeight: CGFloat
    
    /* Monster move configuration */
    var lastTime: TimeInterval = 0.0
    var moveRate : TimeInterval = 0.5
    var timeSinceMove: TimeInterval = 0.0

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, difficulty: TimeInterval) {
        TileWidth = size.width / CGFloat(Game.numCols)
        TileHeight = (size.height * 0.75) / CGFloat(Game.numRows)
        moveRate = difficulty
        
        /* Configure */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        /* Create and configure layers */
        let pointBotLeft = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2)
        let pointCenter = CGPoint(x: 0, y: 0)
        let xLeft = -self.size.width / 2
        let xRight = self.size.width / 2
        let yBot = -self.size.height / 2
        
        configureLayer(parentLayer: self, childLayer: gameLayer, position: pointCenter, zPosition: LayerZPos.gameLayerZ)
        configureLayer(parentLayer: gameLayer, childLayer: tileLayer, position: pointBotLeft, zPosition: LayerZPos.tileLayerZ)
        configureLayer(parentLayer: gameLayer, childLayer: objectLayer, position: pointBotLeft, zPosition: LayerZPos.objectLayerZ)
        configureLayer(parentLayer: gameLayer, childLayer: touchableLayer, position: pointCenter, zPosition: LayerZPos.touchableLayerZ)
        
        configureLayer(parentLayer: gameLayer, childLayer: pauseLayer, position: pointCenter, zPosition: LayerZPos.pauseLayerZ)
        configureLayer(parentLayer: gameLayer, childLayer: gameOverLayer, position: pointCenter, zPosition: LayerZPos.gameOverLayerZ)
        configureLayer(parentLayer: gameLayer, childLayer: menuLayer, position: pointCenter, zPosition: LayerZPos.menuLayerZ)
        
        pauseLayer.isHidden = true
        gameOverLayer.isHidden = true
        menuLayer.isHidden = true
    
        let readyPos = CGPoint(x: 0, y: 0)
        
        _ = TouchableLabel(text: "Press To Play", name: "Ready", pos: readyPos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)
        
        let baseLine: CGFloat = TileHeight * CGFloat(Game.numRows) - self.size.height / 2
        let labelHeight = touchableLayer.childNode(withName: "Ready")!.frame.height
        let btnSize = CGSize(width: TileWidth * 2, height: TileHeight * 2)

        let scorePos = CGPoint(x: xLeft, y: baseLine)
        _ = TouchableLabel(text: "SCORE: ", name: "Score", pos: scorePos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .left)
        
        let highScorePos = CGPoint(x: xLeft, y: baseLine + labelHeight * 1.75)
        _ = TouchableLabel(text: "HIGH SCORE: ", name: "High Score", pos: highScorePos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .left)

        let pausePos = CGPoint(x: xRight, y: baseLine + labelHeight * 1.75)
        _ = TouchableLabel(text: "PAUSE", name: "Pause", pos: pausePos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .right)

        
        let menuPos = CGPoint(x: xRight, y: baseLine + labelHeight * 3.5)
        _ = TouchableLabel(text: "MENU", name: "Menu", pos: menuPos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .right)
        
        arrowPad = ArrowPad(arrSize: btnSize, xRight: xRight, yBot: yBot, layer: touchableLayer)
        settingPad = SettingPad(arrSize: btnSize, xPos: xLeft, yPos: baseLine + labelHeight * 3.5, layer: touchableLayer)
        
        /*
        
        let downPos = CGPoint(x: xRight - btnSize.width, y: baseLine)
        _ = TouchableLabel(text: "DOWN", name: "Down Alpha", pos: downPos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .right)
        
        let upPos = CGPoint(x: xRight, y: baseLine)
        _ = TouchableLabel(text: "UP", name: "Up Alpha", pos: upPos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .bottom, horzAlign: .right)
 */
        
        startNewGame(stage: Game.initialStage, score: 0)
 
    }
    
    // MARK: - General
    func levelMessage(message: String) {
        let readyPos = CGPoint(x: 0, y: 0)

        _ = TouchableLabel(text: message, name: "Ready", pos: readyPos, layer: touchableLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)
    }
    
    func pauseGame() {
        let pauseAction = SKAction.run {
            self.view?.isPaused = true
        }
        self.run(pauseAction)
    }
    
    func unpauseGame() {
        self.view?.isPaused = false
    }
    
    func configureLayer(parentLayer: SKNode, childLayer: SKNode, position: CGPoint, zPosition: CGFloat) {
        childLayer.position = position
        childLayer.zPosition = zPosition
        parentLayer.addChild(childLayer)
    }
    
    func configureSKSpriteNode(node: SKSpriteNode, imageName: String, position: CGPoint, size: CGSize, alpha: CGFloat) {
        node.texture = SKTexture(imageNamed: imageName)
        node.position = position
        node.zPosition = LayerZPos.touchableLayerZ
        node.size = size
        node.alpha = alpha
        touchableLayer.addChild(node)
    }
    
    // MARK: - New Game Flow
    func startNewGame(stage: Int, score: Int) {
        objectLayer.removeAllChildren()
        tileLayer.removeAllChildren()
        pauseLayer.removeAllChildren()
        gameOverLayer.removeAllChildren()
        menuLayer.removeAllChildren()
        Player.sharedIntance.resetColRow()
        
        self.score = score
        level = Level(stage: stage)
        addTiles()
        beginGame()
        pauseGame()
    }
    
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
                //if level.tileAt(col: col, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(col: col, row: row)
                    tileLayer.addChild(tileNode)
                //}
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
        let scoreLabel = touchableLayer.childNode(withName: "Score")! as! SKLabelNode
        let highScoreLabel = touchableLayer.childNode(withName: "High Score")! as! SKLabelNode
        scoreLabel.text = "SCORE: \(score)"
        highScoreLabel.text = "HIGH SCORE: \(highScore)"
        
        Music.loadBackgroundMusic(scene: self)

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
        let touchedNode = touchableLayer.nodes(at: location).first

        print("Touch at  \(location.x) - \(location.y) with count:  \(self.nodes(at: location).count)")

        let isGamePaused = self.view?.isPaused
        
        if isGamePaused! && touchableLayer.childNode(withName: "Ready") != nil {
            handleFirstTouchReadyText()
            return
        }
        
        /* Touch on Layers */
        if !pauseLayer.isHidden {
            handleTouchOnPauseLayer()
            return
        }
        
        if !gameOverLayer.isHidden {
            handleTouchOnGameOverLayer(touches: touches)
            return
        }
        
        if !menuLayer.isHidden {
            handleTouchOnMenuLayer(touches: touches)
            return
        }
        
        /* Touch on UI */
        if touchedNode == touchableLayer.childNode(withName: "Menu") {
            handleTouchOnMenuLabel()
            return
        }
        if touchedNode == touchableLayer.childNode(withName: "Pause") {
            let bg = SKSpriteNode(color: UIColor.blue, size: self.size)
            bg.zPosition = LayerZPos.pauseLayerZ - 1
            bg.position = CGPoint(x: 0, y: 0)
            pauseLayer.addChild(bg)
            
            handleTouchOnPauseLabel()
            return
        }
        
        if touchedNode == touchableLayer.childNode(withName: "Mute") {
            Music.toggleSound(scene: self, layer: touchableLayer)
            return
        }
        
        if touchedNode == touchableLayer.childNode(withName: "Up Alpha") {
            Music.playSound(scene: self, sound: Sounds.click)
            arrowPad?.increaseAlpha()
            arrowPad?.setAllArrowAlpha(to: arrowPad!.alpha)
            return
        }
        
        if touchedNode == touchableLayer.childNode(withName: "Down Alpha") {
            Music.playSound(scene: self, sound: Sounds.click)
            arrowPad?.decreaseAlpha()
            arrowPad?.setAllArrowAlpha(to: arrowPad!.alpha)
            return
        }
        

        /* Touch on arrow */
        if !(isGamePaused)! && !isGameOver && touchedNode != nil && arrowPad!.containsNode(node: touchedNode) {
            Music.playSound(scene: self, sound: Sounds.playerMove)
            let newPlayerDirection = getDirectionOfTouch(node: touchedNode!)
            let newImage = "Player\(newPlayerDirection.rawValue)"
            Player.sharedIntance.getSprite().texture = SKTexture(imageNamed: newImage)
            self.handleMove(direction: newPlayerDirection)
            return
        }
    }
    
    func addLayerBackground(layer: SKNode, zPos: CGFloat) {
        let bg = SKSpriteNode(color: UIColor.darkGray, size: self.size)
        bg.zPosition = zPos - 1
        bg.position = CGPoint(x: 0, y: 0)
        layer.addChild(bg)
    }
    
    // MARK: - Handle touch on Label
    func hideLayerUnpauseGame(layer: SKNode) {
        layer.removeAllChildren()
        layer.isHidden = true
        unpauseGame()
    }
    
    func showLayerPauseGame(layer: SKNode) {
        layer.isHidden = false
        pauseGame()
    }
    
    func handleTouchOnMenuLabel() {
        Music.playSound(scene: self, sound: Sounds.click)
        addLayerBackground(layer: menuLayer, zPos: LayerZPos.menuLayerZ)

        let cancelPos = CGPoint(x: 0, y: 0)
        
        _ = TouchableLabel(text: "Leaving Game, Are You Sure?", name: "Menu", pos: cancelPos, layer: menuLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)

        let labelHeight = menuLayer.childNode(withName: "Menu")!.frame.height
  
        let yesPos = CGPoint(x: 0, y: 0 - labelHeight * 2)
        _ = TouchableLabel(text: "Yes", name: "Yes", pos: yesPos, layer: menuLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)
        
        let noPos = CGPoint(x: 0, y: 0 - labelHeight * 4)
        _ = TouchableLabel(text: "No", name: "No", pos: noPos, layer: menuLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)

        showLayerPauseGame(layer: menuLayer)
    }
    
    func handleTouchOnPauseLabel() {
        Music.playSound(scene: self, sound: Sounds.click)
        addLayerBackground(layer: pauseLayer, zPos: LayerZPos.pauseLayerZ)

        let centre = CGPoint(x: 0, y: 0)
        _ = TouchableLabel(text: Message.newGame, name: "New Game", pos: centre, layer: pauseLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)
        
        showLayerPauseGame(layer: pauseLayer)
    }

    func handleFirstTouchReadyText() {
        let readyLabel = touchableLayer.childNode(withName: "Ready")
        readyLabel!.removeFromParent()
        unpauseGame()
    }
    
    // MARK: - Handle touch on Layers
    
    
    func handleTouchOnPauseLayer() {
        hideLayerUnpauseGame(layer: pauseLayer)
    }
    
    func handleTouchOnGameOverLayer(touches: Set<UITouch>) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: gameOverLayer)
        let touchedNode = gameOverLayer.nodes(at: location).first
        
        let newGameLabel = gameOverLayer.childNode(withName: "New Game")
        let restartLevelLabel = gameOverLayer.childNode(withName: "Restart Level")
        
        if touchedNode == newGameLabel || touchedNode == restartLevelLabel {
            gameOverLayer.isHidden = true
            isGameOver = false
        }

        if touchedNode == newGameLabel {
            startNewGame(stage: Game.initialStage, score: 0)
            levelMessage(message: Message.newGame)
        }
        
        if touchedNode == restartLevelLabel {
            self.interstitialDelegate?.showInterstitialAd()
            startNewGame(stage: level.getStage(), score: self.score)
            levelMessage(message: "Restart Level! Tap To Continue!")
        }
    }
    
    func handleTouchOnMenuLayer(touches: Set<UITouch>) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: menuLayer)
        let touchedNode = menuLayer.nodes(at: location).first
        
        if touchedNode == menuLayer.childNode(withName: "Yes") {
            Player.sharedIntance.resetColRow()
            let scene: SKScene = MenuScene(size: self.size)
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
        }
        
        if touchedNode == menuLayer.childNode(withName: "No") {
            hideLayerUnpauseGame(layer: menuLayer)
        }
    }
    
    // MARK: - Enemy move
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
                let newImage = "Enemy\(nextMove.rawValue)"
                enemy.getSprite().texture = SKTexture(imageNamed: newImage)
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
        updateScore()
        updateHighScore()
        checkNextLevel()
        checkGameOver()
    }
    
    // MARK: - Routine check
    func checkNextLevel() {
        if level.enemies.count == 0 {
            level.nextStage()
            startNewGame(stage: level.getStage(), score: self.score)
            levelMessage(message: "Next Level! Tap To Continue!")
        }
    }
    
    func checkGameOver() {
        if isGameOver && gameOverLayer.isHidden {
            handleGameOver()
        }
    }
    func updateScore() {
        let scoreLabel = touchableLayer.childNode(withName: "Score")! as! SKLabelNode
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func updateHighScore() {
        if score > highScore {
            highScore = score
            let secondDefaults: UserDefaults = UserDefaults.standard
            secondDefaults.set(highScore, forKey: "Highscore")
            secondDefaults.synchronize()
            
            let highScoreLabel = touchableLayer.childNode(withName: "High Score")! as! SKLabelNode
            highScoreLabel.text = "HIGH SCORE: \(highScore)"
        }
    }
    
    func addScore() {
        self.score += 1
        let scoreLabel = touchableLayer.childNode(withName: "Score")! as! SKLabelNode
        scoreLabel.text = "SCORE: \(score)"
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
            //let newEnemies: Set<Enemy> = [level.spawnNewEnemy(), level.spawnNewEnemy()]
            //addSprites(for: newEnemies)
        }
    }
    
    func handleGameOver() {
        gameOverLayer.isHidden = false
        
        let centre = CGPoint(x: 0, y: 0)

        _ = TouchableLabel(text: "Game Over!", name: "Game Over", pos: centre, layer: gameOverLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)
        
        let labelHeight = gameOverLayer.childNode(withName: "Game Over")!.frame.height
        
        let scoreText: String = (score > highScore) ? "New High Score: \(score)" : "Score: \(score)"
        let scorePos = CGPoint(x: 0, y: -labelHeight * 2)

        
        _ = TouchableLabel(text: scoreText, name: "Game Over", pos: scorePos, layer: gameOverLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)

        let newGamePos = CGPoint(x: 0, y: -labelHeight * 4)

        _ = TouchableLabel(text: "Start New Game", name: "New Game", pos: newGamePos, layer: gameOverLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)

        
    
        let restartPos = CGPoint(x: 0, y: -labelHeight * 6)
        _ = TouchableLabel(text: "Restart Level", name: "Restart Level", pos: restartPos, layer: gameOverLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 15, vertAlign: .center, horzAlign: .center)

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
            Music.playSound(scene: self, sound: Sounds.boxMove)
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
        case touchableLayer.childNode(withName: "Up")!: return Direction.up
        case touchableLayer.childNode(withName: "Down")!: return Direction.down
        case touchableLayer.childNode(withName: "Left")!: return Direction.left
        case touchableLayer.childNode(withName: "Right")!: return Direction.right
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
