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

class Music {
    
    static func loadBackgroundMusic(scene: SKScene) {
        let backgroundMusic = SKAudioNode(fileNamed: "music.m4a")
        backgroundMusic.autoplayLooped = true
        scene.addChild(backgroundMusic)
    }
}
