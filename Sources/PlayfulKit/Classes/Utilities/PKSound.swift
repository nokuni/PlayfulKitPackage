//
//  PKSound.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import AVFoundation
import SwiftUI

// I noticed that if a sound duration is very short, the infinite loop (numberOfLoops = -1) works on the simulator but not on a real device. It starts playing the sound for 1 second then stops.

public class PKSound {
    
    public init() { }
    
    public struct BackgroundMusic {
        let name: String
        public var audio: AVAudioPlayer?
    }
    
    public struct SFX {
        let name: String
        public var audio: AVAudioPlayer?
    }
    
    public var backgroundMusic: BackgroundMusic?
    public var soundEffects = [SFX]()
    
    @AppStorage("music") public var isMusicEnabled = true
    @AppStorage("sfx") public var isSFXEnabled = true
    
    private var timer: Timer?
    private var numberOfRepeat: Int = 0
    
    public func playMusic(name: String, volume: Float, loops: Int) {
        if isMusicEnabled {
            if let url = Bundle.main.url(forResource: name, withExtension: nil),
               let audio = try? AVAudioPlayer(contentsOf: url) {
                if backgroundMusic == nil {
                    backgroundMusic = BackgroundMusic(name: name, audio: audio)
                    backgroundMusic!.audio!.numberOfLoops = loops
                    backgroundMusic!.audio!.volume = volume
                    backgroundMusic!.audio!.prepareToPlay()
                    backgroundMusic!.audio!.play()
                }
            }
        }
    }
    
    public func playSFX(name: String,
                        loops: Int,
                        volume: Float,
                        isSpammable: Bool = false) {
        if isSFXEnabled {
            if let url = Bundle.main.url(forResource: name, withExtension: nil),
               let audio = try? AVAudioPlayer(contentsOf: url) {
                
                if !soundEffects.contains(where: { $0.name == name }) {
                    let soundEffect = SFX(name: name, audio: audio)
                    soundEffects.append(soundEffect)
                }
                
                if let index = soundEffects.firstIndex(where: { $0.name == name }) {
                    if isSpammable {
                        stopSFX()
                        soundEffects[index].audio!.numberOfLoops = loops
                        soundEffects[index].audio!.volume = volume
                        soundEffects[index].audio!.prepareToPlay()
                        soundEffects[index].audio!.play()
                    } else if !soundEffects[index].audio!.isPlaying {
                        soundEffects[index].audio!.numberOfLoops = loops
                        soundEffects[index].audio!.volume = volume
                        soundEffects[index].audio!.prepareToPlay()
                        soundEffects[index].audio!.play()
                    }
                }
            }
        }
    }
    
    public func stopSFX() {
        soundEffects.forEach {
            $0.audio?.stop()
            $0.audio?.currentTime = 0
        }
    }
    
    // Stop the actual background music to play another.
    public func changeBackgroundMusic(name: String, volume: Float, loops: Int) {
        backgroundMusic?.audio?.stop()
        backgroundMusic = nil
        playMusic(name: name, volume: volume, loops: loops)
    }
    
    // Stop the background music and the sound effects
    public func stopAllSounds() {
        backgroundMusic?.audio?.stop()
        soundEffects.forEach { $0.audio?.stop() }
    }
    
    // Stop the background music
    public func stopBackgroundSound() {
        backgroundMusic?.audio?.stop()
        backgroundMusic = nil
    }
    
    public func stopRepeatedSFX() {
        timer?.invalidate()
    }
    
    // Looping sound method using a timer
    // This method can control the time interval of the looping sound
    public func repeatSoundEffect(timeInterval: TimeInterval,
                                  name: String,
                                  volume: Float,
                                  repeatCount: Int) {
        numberOfRepeat = repeatCount
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            switch true {
            case self.numberOfRepeat == -1:
                self.playSFX(name: name, loops: 0, volume: volume, isSpammable: true)
            case self.numberOfRepeat > 0:
                self.playSFX(name: name, loops: 0, volume: volume, isSpammable: true)
                self.numberOfRepeat -= 1
            default:
                timer.invalidate()
                self.numberOfRepeat = 0
            }
        }
        
        timer?.fire()
    }
}
