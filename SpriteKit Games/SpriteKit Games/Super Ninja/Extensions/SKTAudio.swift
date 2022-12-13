//
//  SKTAudio.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 23/02/23.
//

import AVFoundation

class SKTAudio {
    
    // MARK: - Variable Declrations
    var bgMusic: AVAudioPlayer?
    var soundEffect: AVAudioPlayer?
    static let keyMusic = R.string.localizable.keyMusic()
    static var musicEnabled: Bool = {
        return !UserDefaults.standard.bool(forKey: keyMusic)
    }() {
        didSet {
            let value = !musicEnabled
            UserDefaults.standard.set(value, forKey: keyMusic)
            
            if value {
                SKTAudio.sharedInstance().stopBackgroundMusic()
            }
        }
    }
    
    // MARK: - Class Methods
    func playBackgroundMusicOf(_ fileNamed: String) {
        if !SKTAudio.musicEnabled { return }
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else { return }
        do {
            bgMusic = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            bgMusic = nil
        }
        
        if let bgMusic = bgMusic {
            bgMusic.numberOfLoops = -1
            bgMusic.prepareToPlay()
            bgMusic.play()
        }
     }
    
    func stopBackgroundMusic() {
        if let bgMusic = bgMusic {
            if bgMusic.isPlaying {
                bgMusic.stop()
            }
        }
    }
    
    func pauseBackgroundMusic() {
        if let bgMusic = bgMusic {
            if bgMusic.isPlaying {
                bgMusic.pause()
            }
        }
    }
    
    func resumeBackgroundMusic() {
        if let bgMusic = bgMusic {
            if bgMusic.isPlaying {
                bgMusic.play()
            }
        }
    }
    
    func playSoundEffectOf(_ fileNamed: String) {
        guard let url = Bundle.main.url(forResource: fileNamed, withExtension: nil) else { return }
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            soundEffect = nil
        }
        
        if let soundEffect = soundEffect {
            soundEffect.numberOfLoops = 0
            soundEffect.prepareToPlay()
            soundEffect.play()
        }
    }
    
    static func sharedInstance() -> SKTAudio {
        return SKTAudioInstance
    }
}

private let SKTAudioInstance = SKTAudio()

