//
//  GameViewController.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 11/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate, InterstitialDelegate {
    
    var menuScene: MenuScene?
    var gameScene: GameScene?
    
    var bannerView: GADBannerView!
    var interstitialAd : GADInterstitial!

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        let size = skView.bounds.size
        let scene = MenuScene(size: size)
        scene.viewController = self
        scene.scaleMode = .aspectFill
        scene.size = size
        skView.isMultipleTouchEnabled = false
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        if bannerView == nil {
            initializeBanner()
        }
        
        loadRequest()
        
        interstitialAd = createAndLoadInterstitial()
    }
    
    // MARK: - AdMob Functions
    func loadRequest() {
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    func initializeBanner() {
        // Create a banner ad and add it to the view hierarchy.
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        view!.addSubview(bannerView)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-4301502070358132/8723206604")
        interstitialAd.delegate = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        return interstitialAd
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createAndLoadInterstitial()
    }
    
    func showInterstitialAd() {
        if interstitialAd.isReady {
            print("showing interstitial")
            interstitialAd.present(fromRootViewController: self)
        } else {
            print("interstitial not ready")
        }
    }
}
