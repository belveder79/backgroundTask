//
//  BackgroundTask.swift
//
//  Created by Yaro on 8/27/16.
//  Copyright © 2016 Yaro. All rights reserved.
//

import AVFoundation

@objc(SwiftAudioProxy)
public class SwiftAudioProxy : NSObject {
    
    // MARK: - Vars
    var player = AVAudioPlayer()
    var timer = Timer()
    var proxyFile:String = String()
    
    // MARK: - Methods
    @objc
    public func startRunningProxy(file: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(interrupted), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        proxyFile = file
        self.proxy(file: proxyFile)
    }
    
    @objc
    public func stopRunningProxy() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        player.stop()
    }
    
    @objc
    fileprivate func interrupted(_ notification: Notification) {
        if notification.name == AVAudioSession.interruptionNotification && notification.userInfo != nil {
            var info = notification.userInfo!
            var intValue = 0
            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
            if intValue == 1 { proxy(file: proxyFile) }
        }
    }
    
    @objc
    fileprivate func proxy(file: String) {
        do {
            //let bundle = Bundle.main.path(forResource: file, ofType: "wav")
            //let alertSound = URL(fileURLWithPath: bundle!)
            let alertSound = URL(fileURLWithPath: file)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
            try self.player = AVAudioPlayer(contentsOf: alertSound)
            // Play audio forever by setting num of loops to -1
            self.player.numberOfLoops = -1
            self.player.volume = 0.01
            self.player.prepareToPlay()
            self.player.play()
        } catch { print(error) }
    }
}
