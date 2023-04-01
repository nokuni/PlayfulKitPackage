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
    
    private enum SoundError: String {
        case soundNameNotFound = "The sound name provided has not been found."
        case audioPlayerIssue = "The audio player may have an issue."
        case sequenceSoundIssue = "One or few sounds have issues being added to the sequence."
    }
    
    private var musics = [Music]()
    private var soundEffects = [SFX]()
    
    private var musicSequence = [Music]()
    
    @AppStorage("music") public var isMusicEnabled = true
    @AppStorage("sfx") public var isSFXEnabled = true
    
    private var timer: Timer?
    private var numberOfRepeat: Int = 0
    private var isPlayingInSequence: Bool = false
    private var currentMusicSequenceIndex: Int = 0
    
    /// Play a music (Usually medium/long duration sound).
    public func playMusic(name: String,
                          volume: Float = 0.1,
                          loops: Int = 0,
                          isRepeatingForever: Bool = false) {
        guard isMusicEnabled else { return }
        try? addMusic(name: name)
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
                                  volume: Float = 0.1) throws {
        isPlayingInSequence = true
        do {
            try addMusicSequence(names: names)
        } catch {
            throw SoundError.sequenceSoundIssue.rawValue
        }
        let selectedMusics = musics.filter { names.contains($0.name) }
        musicSequence = selectedMusics
        let currentMusic = musicSequence[currentMusicSequenceIndex]
        playMusic(name: currentMusic.name, volume: volume)
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio stopped playing")
            stopMusic()
            playNextMusicInSequence()
        }
    }
    
    private func addMusic(name: String) throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            throw SoundError.soundNameNotFound.rawValue
        }
        guard let audio = try? AVAudioPlayer(contentsOf: url) else {
            throw SoundError.audioPlayerIssue.rawValue
        }
        
        if !musics.contains(where: { $0.name == name }) {
            let music = Music(name: name, audio: audio)
            music.audio?.delegate = self
            musics.append(music)
        }
    }
    
    private func addMusicSequence(names: [String]) throws {
        for name in names {
            do {
                try addMusic(name: name)
            } catch {
                throw SoundError.sequenceSoundIssue.rawValue
            }
        }
    }
    
    private func playNextMusicInSequence() {
        guard isPlayingInSequence else { return }
        guard currentMusicSequenceIndex < (musicSequence.count - 1) else {
            currentMusicSequenceIndex = 0
            return
        }
        currentMusicSequenceIndex += 1
        let music = musicSequence[currentMusicSequenceIndex]
        playMusic(name: music.name, volume: music.audio?.volume ?? 0.1)
    }
    
    /// Play a SFX (Usually short duration sound).
    public func playSFX(name: String,
                        loops: Int,
                        volume: Float,
                        isSpammable: Bool = false) {
        guard isSFXEnabled else { return }
        addSFX(name: name)
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
    
    private func addSFX(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let audio = try? AVAudioPlayer(contentsOf: url) else { return }
        if !soundEffects.contains(where: { $0.name == name }) {
            let soundEffect = SFX(name: name, audio: audio)
            soundEffect.audio?.delegate = self
            soundEffects.append(soundEffect)
        }
    }
    
    /// Stop the current music to play another.
    public func changeMusic(name: String, volume: Float, loops: Int, isRepeatedForever: Bool) {
        stopMusic()
        playMusic(name: name, volume: volume, loops: loops, isRepeatingForever: isRepeatedForever)
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
        musicSequence.forEach { $0.audio?.stop() }
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
