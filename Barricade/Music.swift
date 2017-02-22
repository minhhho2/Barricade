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
}

class Music {
    
    static func loadBackgroundMusic(scene: SKScene) {
        let backgroundMusic = SKAudioNode(fileNamed: "music.m4a")
        backgroundMusic.autoplayLooped = true
        scene.addChild(backgroundMusic)
    }
    
    static func preloadSounds() {
        do {
            let sounds : Array<String> = ["click", "playerMove"]
            for sound in sounds {
                let path : String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url : URL = URL(fileURLWithPath: path)
                let player : AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                
            }
        } catch {
        }
    }
    
    static func getSound(sound: Sounds) -> SKAction {
        let filename = sound.rawValue
        return SKAction.playSoundFileNamed(filename, waitForCompletion: false)

    }
}
