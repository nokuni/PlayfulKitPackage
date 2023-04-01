//
//  SoundManager.swift
//  PlayfulKit
//
//  Created by Maertens Yann-Christophe on 11/08/22.
//

import AVFoundation
import SwiftUI

// I noticed that if a sound duration is very short, the infinite loop (numberOfLoops = -1) works on the simulator but not on a real device. It starts playing the sound for 1 second then stops.

final public class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    public override init() { }
    
    private struct Music: Hashable {
        public let name: String
        public var audio: AVAudioPlayer?
    }
    
    private struct SFX: Hashable {
        public let name: String
        public var audio: AVAudioPlayer?
    }
    
    private var musics = Set<Music>()
    private var soundEffects = Set<SFX>()
    
    private var musicsThatAlreadyPlayed = Set<Music>()
    
    @AppStorage("music") public var isMusicEnabled = true
    @AppStorage("sfx") public var isSFXEnabled = true
    
    private var timer: Timer?
    private var numberOfRepeat: Int = 0
    
    public func playMusic(name: String,
                          volume: Float = 0.1,
                          loops: Int = 1,
                          isRepeatingForever: Bool = false) {
        
        guard isMusicEnabled else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let audio = try? AVAudioPlayer(contentsOf: url) else { return }
        
        if !musics.contains(where: { $0.name == name }) {
            let music = Music(name: name, audio: audio)
            music.audio?.delegate = self
            musics.insert(music)
        }
        
        if let index = musics.firstIndex(where: { $0.name == name }) {
            if !musics[index].audio!.isPlaying {
                musics[index].audio!.numberOfLoops = isRepeatingForever ? -1 : loops
                musics[index].audio!.volume = volume
                musics[index].audio!.prepareToPlay()
                musics[index].audio!.play()
            }
        }
    }
    
    public func playMusicSequence(names: [String],
                                  volume: Float = 0.1,
                                  loops: Int = 1,
                                  isRepeatingForever: Bool = false) {
        guard let randomMusicName = names.randomElement() else { return }
        playMusic(name: randomMusicName, volume: volume, loops: loops, isRepeatingForever: isRepeatingForever)
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio stopped playing")
            stopMusic()
        }
    }
    
    public func playSFX(name: String,
                        loops: Int,
                        volume: Float,
                        isSpammable: Bool = false) {
        guard isSFXEnabled else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let audio = try? AVAudioPlayer(contentsOf: url) else { return }
        
        if !soundEffects.contains(where: { $0.name == name }) {
            let soundEffect = SFX(name: name, audio: audio)
            soundEffects.insert(soundEffect)
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
    
    // Stop the actual background music to play another.
    public func changeMusic(name: String, volume: Float, loops: Int) {
        stopMusic()
        playMusic(name: name, volume: volume, loops: loops)
    }
    
    /// Stop the current music and SFX playing.
    public func stopAllSounds() {
        stopMusic()
        stopSFX()
        stopRepeatedSFX()
    }
    
    /// Stop the current music playing.
    public func stopMusic() {
        musics.forEach { $0.audio?.stop() }
    }
    
    /// Stop the current SFX playing.
    public func stopSFX() {
        soundEffects.forEach {
            $0.audio?.stop()
            $0.audio?.currentTime = 0
        }
    }
    
    /// Stop the current SFX playing repeatedly.
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
