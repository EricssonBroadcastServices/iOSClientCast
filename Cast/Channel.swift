//
//  CastChannel.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-11-30.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import GoogleCast

public class Channel: GCKCastChannel {
    public static let defaultNamespace: String = "urn:x-cast:com.ericsson.cast.receiver"
    
    public init(namepace: String = Channel.defaultNamespace) {
        super.init(namespace: namepace)
    }
    
    fileprivate var onTracksUpdated: (TracksUpdated) -> Void = { _ in }
    fileprivate var onTimeshiftEnabled: (Bool) -> Void = { _ in }
    fileprivate var onVolumeChanged: (VolumeChanged) -> Void = { _ in }
    fileprivate var onDurationChanged: (Int64) -> Void = { _ in }
    fileprivate var onStartTimeLive: (Int64) -> Void = { _ in }
    fileprivate var onProgramChanged: (String) -> Void = { _ in }
    fileprivate var onSegmentMissing: (Int64) -> Void = { _ in }
    fileprivate var onAutoplay: (Bool) -> Void = { _ in }
    fileprivate var onIsLive: (Bool) -> Void = { _ in }
    fileprivate var onError: (CastError) -> Void = { _ in }
    
    
    public override func didReceiveTextMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        
        let decoder = JSONDecoder()
        do {
            let messageType = try decoder.decode(MessageType.self, from: data)
            switch messageType {
            case .tracksUpdated:
                let event = try decoder.decode(TracksUpdated.self, from: data)
                onTracksUpdated(event)
            case .timeShiftEnabled:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Bool>.self, from: data)
                onTimeshiftEnabled(rawEvent.value)
            case .volumeChange:
                let event = try decoder.decode(VolumeChanged.self, from: data)
                onVolumeChanged(event)
            case .durationChange:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Int64>.self, from: data)
                onDurationChanged(rawEvent.value)
            case .startTimeLive:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Int64>.self, from: data)
                onStartTimeLive(rawEvent.value)
            case .programChanged:
                let event = try decoder.decode(ProgramChanged.self, from: data)
                onProgramChanged(event.programId)
            case .segmentMissing:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Int64>.self, from: data)
                onSegmentMissing(rawEvent.value)
            case .autoplay:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Bool>.self, from: data)
                onAutoplay(rawEvent.value)
            case .isLive:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Bool>.self, from: data)
                onIsLive(rawEvent.value)
            case .error:
                let event = try decoder.decode(CastError.ReceiverError.self, from: data)
                onError(.receiver(reason: event))
            }
        }
        catch {
            onError(.sender(reason: .unsupportedMessage(message: message, error: error)))
        }
    }
}

extension Channel {
    /// Signals the tracks have been updated
    ///
    /// - parameter tracksUpdated: The latest available tracks
    @discardableResult
    public func onTracksUpdated(callback: @escaping (TracksUpdated) -> Void) -> Channel {
        onTracksUpdated = callback
        return self
    }
    
    /// Signals whether timeshift is enabled in the controls or not.
    ///
    /// - parameter enabled: If timeshift is enabled or not
    @discardableResult
    public func onTimeshiftEnabled(callback: @escaping (Bool) -> Void) -> Channel {
        onTimeshiftEnabled = callback
        return self
    }
    
    /// Signals a change in the volume status.
    ///
    /// - parameter volumeChanged: The active volume
    @discardableResult
    public func onVolumeChanged(callback: @escaping (VolumeChanged) -> Void) -> Channel {
        onVolumeChanged = callback
        return self
    }
    
    /// Signals a change in the duration of the media being played.
    ///
    /// - parameter duration: The new duration of the media
    @discardableResult
    public func onDurationChanged(callback: @escaping (Int64) -> Void) -> Channel {
        onDurationChanged = callback
        return self
    }
    
    /// Returns start time of the live stream
    ///
    /// - parameter startTime: In milliseconds since 1970/01/01 (ie unix epoch time)
    @discardableResult
    public func onStartTimeLive(callback: @escaping (Int64) -> Void) -> Channel {
        onStartTimeLive = callback
        return self
    }
    
    /// Signals a change in the program of a given channel.
    ///
    /// - parameter programId: The programId for the program
    @discardableResult
    public func onProgramChanged(callback: @escaping (String) -> Void) -> Channel {
        onProgramChanged = callback
        return self
    }
    
    /// Signals seek is cancelled because segment is missing.
    ///
    /// - parameter position: The possition where segment is missing
    @discardableResult
    public func onSegmentMissing(callback: @escaping (Int64) -> Void) -> Channel {
        onSegmentMissing = callback
        return self
    }
    
    /// Signals whether autoplay is enabled or not.
    ///
    /// - parameter enabled: If autoplay is enabled or not
    @discardableResult
    public func onAutoplay(callback: @escaping (Bool) -> Void) -> Channel {
        onAutoplay = callback
        return self
    }
    
    /// Signals whether the stream is a live stream or not
    ///
    /// - parameter enabled: If stream is live or not
    @discardableResult
    public func onIsLive(callback: @escaping (Bool) -> Void) -> Channel {
        onIsLive = callback
        return self
    }
    /// Signals an error occured
    ///
    /// - parameter error: The error that occured
    @discardableResult
    public func onError(callback: @escaping (CastError) -> Void) -> Channel {
        onError = callback
        return self
    }
    
}

extension Channel {
    /// Deliver the message to the `ChromeCast` receiver, reporting any errors that occur.
    fileprivate func send(message: String) {
        var gckError: GCKError?
        sendTextMessage(message, error: &gckError)
        if let error = gckError {
            onError(.googleCast(error: error))
        }
    }
}

// MARK: - Refresh Controls
extension Channel {
    /// After joining a session, it might be necessary to request the constrols' status (volume level, timeshift enabled, tracks, startTimeLive). By sending this message to the receiver, it will then answer with updated controls.
    public func refreshControls() {
        do {
            let data = try JSONEncoder().encode(RefreshControls())
            guard let message = String(data: data, encoding: .utf8) else { return }
            send(message: message)
        }
        catch {
            onError(.sender(reason: .failedToSerializeMessage(error: error, type: "RefreshControls")))
        }
    }
    
    /// Internal message delivered to the receiver when a user asks for control refreshment.
    internal struct RefreshControls: Encodable {
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: BaseKeys.self)
            try container.encode("refreshcontrols", forKey: .type)
        }
        
        internal enum BaseKeys: CodingKey {
            case type
        }
    }
}

// MARK: - Subtitles
extension Channel {
    /// Updates the currently displayed text track on the receiver
    ///
    /// - parameter textTrack: The track to display
    public func use(textTrack: Track) {
        use(subtitle: textTrack.language)
    }
    
    /// Updates the currently displayed text track on the receiver
    ///
    /// - parameter subtitle: The language code to display
    public func use(subtitle: String) {
        do {
            let event = ShowTextTrack(language: subtitle)
            let data = try JSONEncoder().encode(event)
            guard let message = String(data: data, encoding: .utf8) else { return }
            send(message: message)
        }
        catch {
            onError(.sender(reason: .failedToSerializeMessage(error: error, type: "ShowTextTrack")))
        }
    }
    
    /// Hides any subtiltes currently displayed
    public func hideSubtitles() {
        do {
            let event = HideTextTrack()
            let data = try JSONEncoder().encode(event)
            guard let message = String(data: data, encoding: .utf8) else { return }
            send(message: message)
        }
        catch {
            onError(.sender(reason: .failedToSerializeMessage(error: error, type: "HideTextTrack")))
        }
    }
    
    /// Internal message detailing a subtitle change request
    internal struct ShowTextTrack: Encodable {
        internal let language: String
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: BaseKeys.self)
            try container.encode("showtexttrack", forKey: .type)
            
            var nested = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
            try nested.encode(language, forKey: .language)
        }
        
        internal enum BaseKeys: CodingKey {
            case type
            case data
        }
        internal enum DataKeys: CodingKey {
            case language
        }
    }
    
    /// Internal message instructing the receiver to hide text tracks
    internal struct HideTextTrack: Encodable {
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: BaseKeys.self)
            try container.encode("hidetexttrack", forKey: .type)
        }
        
        internal enum BaseKeys: CodingKey {
            case type
        }
    }
}


// MARK: - Audio
extension Channel {
    /// Updates the currently active audio track on the receiver
    ///
    /// - parameter audioTrack: The track to display
    public func use(audioTrack: Track) {
        use(audio: audioTrack.language)
    }
    
    /// Updates the currently active audio track on the receiver
    ///
    /// - parameter audio: The language code to display
    public func use(audio: String) {
        do {
            let event = EnableAudioTrack(language: audio)
            let data = try JSONEncoder().encode(event)
            guard let message = String(data: data, encoding: .utf8) else { return }
            send(message: message)
        }
        catch {
            onError(.sender(reason: .failedToSerializeMessage(error: error, type: "EnableAudioTrack")))
        }
    }
    
    /// Internal message detailing an audio change request
    internal struct EnableAudioTrack: Encodable {
        internal let language: String
        
        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: BaseKeys.self)
            try container.encode("enableaudiotrack", forKey: .type)
            
            var nested = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
            try nested.encode(language, forKey: .language)
        }
        
        internal enum BaseKeys: CodingKey {
            case type
            case data
        }
        internal enum DataKeys: CodingKey {
            case language
        }
    }
}






