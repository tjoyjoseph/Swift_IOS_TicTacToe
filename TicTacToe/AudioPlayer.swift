//
//  AudioPlayer.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 06/12/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer {
    var player = AVAudioPlayer();
    
    init() {
        let path = Bundle.main.path(forResource: "backgroundAudio", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1;
            player.setVolume(0.6, fadeDuration: 0)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    private static var ap = AudioPlayer();
    
    static func playAudio()
    {
        self.ap.player.prepareToPlay();
        self.ap.player.play();
    }
    
    static func stopAudio()
    {
        self.ap.player.stop();
    }
    
    static func setVolume(vol:Float)
    {
        self.ap.player.setVolume(vol, fadeDuration: 0)
    }
    


}
