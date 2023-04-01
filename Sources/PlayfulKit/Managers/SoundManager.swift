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
    private struct SoundConfiguration {
        var numberOfLoops: Int
        var volume: Float
    }
    
    private enum SoundError: String {
        case soundNameNotFound = "The sound name provided has not been found."
        case audioPlayerIssue = "The audio player may have an issue."
        case soundPlayIssue = "The sound has an issue being played."
        case sequenceSoundPlayIssue = "One or few sounds have issues being played."
        case sequenceSoundAddIssue = "One or few sounds have issues being added to the sequence."
    }
    
    private var musics = [Music]()
    private var soundEffects = [SFX]()
    
    private var musicSequence = [Music]()
    
    @AppStorage("music") public var isMusicEnabled = true
    @AppStorage("sfx") public var isSFXEnabled = true
    
    private var timer: Timer?
    private var numberOfRepeat: Int = 0
    private var isPlayingInSequence: Bool = false
    private var isMusicSequenceLooping: Bool = true
    private var currentMusicSequenceIndex: Int = 0
    
    // MARK: - PUBLIC
    
    /// Play a music (Usually medium/long duration sound).
    public func playMusic(name: String,
                          volume: Float = 0.1,
                          loops: Int = 0,
                          isRepeatingForever: Bool = false) throws {
        guard isMusicEnabled else { return }
        do {
            try addMusic(name: name)
        } catch {
            throw SoundError.soundNameNotFound.rawValue
        }
        if let index = musics.firstIndex(where: { $0.name == name }) {
            let configuration = SoundConfiguration(numberOfLoops: isRepeatingForever ? -1 : loops,
                                                   volume: volume)
            configureMusic(index: index, configuration: configuration)
        }
    }
    
    /// Play a sequence of music one after another and looping when all sound have been played.
    public func playMusicSequence(names: [String],
                                  volume: Float = 0.1,
                                  isLooping: Bool = true) throws {
        isPlayingInSequence = true
        isMusicSequenceLooping = isLooping
        do {
            try addMusicSequence(names: names)
        } catch {
            throw SoundError.sequenceSoundAddIssue.rawValue
        }
        let selectedMusics = musics.filter { names.contains($0.name) }
        musicSequence = selectedMusics
        let currentMusic = musicSequence[currentMusicSequenceIndex]
        do {
            try playMusic(name: currentMusic.name, volume: volume)
        } catch {
            throw SoundError.soundPlayIssue.rawValue
        }
        currentMusicSequenceIndex += 1
    }
    
    /// Play a SFX (Usually short duration sound).
    /// - isSpammable: If true, the current sound can be interrupted by a new one. Otherwise, the current sound is played until it's finished to play the new one.
    public func playSFX(name: String,
                        loops: Int = 0,
                        volume: Float = 0.1,
                        isSpammable: Bool = false) {
        guard isSFXEnabled else { return }
        addSFX(name: name)
        if let index = soundEffects.firstIndex(where: { $0.name == name }) {
            let configuration = SoundConfiguration(numberOfLoops: loops, volume: volume)
            if isSpammable {
                stopSFX()
                configureSFX(index: index, configuration: configuration)
            } else if !soundEffects[index].audio!.isPlaying {
                configureSFX(index: index, configuration: configuration)
            }
        }
        
    }
    
    /// Triggers when an audio finishes playing.
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio stopped playing")
            stopMusic()
            try? playNextMusicInSequence()
        }
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
    
    // MARK: - PRIVATE
    
    private func configureMusic(index: Int, configuration: SoundConfiguration) {
        if !musics[index].audio!.isPlaying {
            musics[index].audio?.numberOfLoops = configuration.numberOfLoops
            musics[index].audio?.volume = configuration.volume
            musics[index].audio?.prepareToPlay()
            musics[index].audio?.play()
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
                throw SoundError.sequenceSoundAddIssue.rawValue
            }
        }
    }
    
    private func playNextMusicInSequence() throws {
        guard isPlayingInSequence else { return }
        guard currentMusicSequenceIndex < musicSequence.count else { return }
        let music = musicSequence[currentMusicSequenceIndex]
        do {
            try playMusic(name: music.name, volume: music.audio?.volume ?? 0.1)
        } catch {
            throw SoundError.sequenceSoundPlayIssue.rawValue
        }
        if music == musicSequence.last {
            if isMusicSequenceLooping { currentMusicSequenceIndex = 0 }
        } else {
            currentMusicSequenceIndex += 1
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
    
    private func configureSFX(index: Int, configuration: SoundConfiguration) {
        soundEffects[index].audio?.numberOfLoops = configuration.numberOfLoops
        soundEffects[index].audio?.volume = configuration.volume
        soundEffects[index].audio?.prepareToPlay()
        soundEffects[index].audio?.play()
    }
}
