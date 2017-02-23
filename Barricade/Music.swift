//
//  Music.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 21/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

enum Sounds: String {
    case playerMove = "playerMove"
    case playerPush = "playerPush"
    case playerDie = "playerDie"
    case click = "click" // "click"
    case newHighScore = "newHighScore"
    case boxMove = "explosion"
}

class Music {
    
    static var isMute: Bool = false
    
    static func loadBackgroundMusic(scene: SKScene) {
        let backgroundMusic = SKAudioNode(fileNamed: "music.m4a")
        backgroundMusic.name = "Background Music"
        backgroundMusic.autoplayLooped = true
        scene.addChild(backgroundMusic)
        if isMute {
            backgroundMusic.run(SKAction.pause())
        }
    }
    
    static func preloadSounds() {
        do {
            let sounds : Array<String> = ["click", "playerMove", "explosion"]
            for sound in sounds {
                let path : String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url : URL = URL(fileURLWithPath: path)
                let player : AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                
            }
        } catch {
        }
    }
    
    
    static func toggleSound(scene: SKScene, layer: SKNode) {
        let bgMusicNode = scene.childNode(withName: "Background Music")
        let muteNode = layer.childNode(withName: "Mute")! as! SKSpriteNode
        
        if isMute {
            bgMusicNode?.run(SKAction.play())
            muteNode.texture = SKTexture(imageNamed: "PlayerLeft")
            isMute = false
        } else {
            bgMusicNode?.run(SKAction.pause())
            muteNode.texture = SKTexture(imageNamed: "PlayerRight")
            isMute = true
        }
    }
    
    static func playSound(scene: SKScene, sound: Sounds) {
        if !isMute {
            let filename = sound.rawValue
            let sound = SKAction.playSoundFileNamed(filename, waitForCompletion: false)
            scene.run(sound)
        }
    }
}
