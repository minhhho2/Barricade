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
    case click = "click"
}

class Music {
    
    static var isMute: Bool = false
    
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
    
    static func playSound(scene: SKScene, sound: Sounds) {
        if !isMute {
            let filename = sound.rawValue
            let sound = SKAction.playSoundFileNamed(filename, waitForCompletion: false)
            scene.run(sound)
        }
    }
}
