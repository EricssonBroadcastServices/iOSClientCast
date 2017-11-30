//
//  CastChannel.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-11-30.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import GoogleCast


public class CastChannel: GCKCastChannel {
    public static let defaultNamespace: String = "urn:x-cast:com.ericsson.cast.receiver"
    
    public init(namepace: String = CastChannel.defaultNamespace) {
        super.init(namespace: namepace)
    }
    
    fileprivate var onTracksUpdated: (TracksUpdated) -> Void = { _ in }
    fileprivate var onTimeshiftEnabled: (Bool) -> Void = { _ in }
    fileprivate var onVolumeChanged: (VolumeChanged) -> Void = { _ in }
    fileprivate var onDurationChanged: (Int64) -> Void = { _ in }
    fileprivate var onStartTimeLive: (Int64) -> Void = { _ in }
    fileprivate var onProgramChanged: (String) -> Void = { _ in }
    fileprivate var onSegmentMissing: (Int64) -> Void = { _ in }
    fileprivate var onError: (CastError) -> Void = { _ in }
    fileprivate var onUnsupportedMessage: (String, Error) -> Void = { _,_ in }
    
    
    public override func didReceiveTextMessage(_ message: String) {
        parse(response: message)
    }
}

extension CastChannel {
    fileprivate func parse(response: String) {
        guard let data = response.data(using: .utf8) else { return }
        
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
                let rawEvent = try decoder.decode(RawSingleValueEvent<String>.self, from: data)
                onProgramChanged(rawEvent.value)
            case .segmentMissing:
                let rawEvent = try decoder.decode(RawSingleValueEvent<Int64>.self, from: data)
                onSegmentMissing(rawEvent.value)
            case .error:
                let event = try decoder.decode(CastError.self, from: data)
                onError(event)
            }
        }
        catch {
            onUnsupportedMessage(response, error)
        }
    }
}



internal enum MessageType: String, Decodable {
    case tracksUpdated = "tracksupdated"
    case timeShiftEnabled = "timeShiftEnabled"
    case volumeChange = "volumechange"
    case durationChange = "durationchange"
    case startTimeLive = "startTimeLive"
    case programChanged = "programchanged"
    case segmentMissing = "segmentmissing"
    case error = "error"
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let string = try container.decode(String.self, forKey: .type)
        guard let msg = MessageType(rawValue: string) else {
            let context = DecodingError.Context(codingPath: [CodingKeys.type], debugDescription: "Key not found")
            throw DecodingError.keyNotFound(CodingKeys.type, context)
        }
        self = msg
    }
    
    internal enum CodingKeys: CodingKey {
        case type
    }
}


extension CastChannel {
    /// Signals the tracks have been updated
    ///
    /// - parameter tracksUpdated: The latest available tracks
    @discardableResult
    public func onTracksUpdated(callback: @escaping (TracksUpdated) -> Void) -> CastChannel {
        onTracksUpdated = callback
        return self
    }
    
    /// Signals whether timeshift is enabled in the controls or not.
    ///
    /// - parameter enabled: If timeshift is enabled or not
    @discardableResult
    public func onTimeshiftEnabled(callback: @escaping (Bool) -> Void) -> CastChannel {
        onTimeshiftEnabled = callback
        return self
    }
    
    /// Signals a change in the volume status.
    ///
    /// - parameter volumeChanged: The active volume
    @discardableResult
    public func onVolumeChanged(callback: @escaping (VolumeChanged) -> Void) -> CastChannel {
        onVolumeChanged = callback
        return self
    }
    
    /// Signals a change in the duration of the media being played.
    ///
    /// - parameter duration: The new duration of the media
    @discardableResult
    public func onDurationChanged(callback: @escaping (Int64) -> Void) -> CastChannel {
        onDurationChanged = callback
        return self
    }
    
    /// Returns start time of the live stream
    ///
    /// - parameter startTime: In milliseconds since 1970/01/01 (ie unix epoch time)
    @discardableResult
    public func onStartTimeLive(callback: @escaping (Int64) -> Void) -> CastChannel {
        onStartTimeLive = callback
        return self
    }
    
    /// Signals a change in the program of a given channel.
    ///
    /// - parameter programId: The programId for the program
    @discardableResult
    public func onProgramChanged(callback: @escaping (String) -> Void) -> CastChannel {
        onProgramChanged = callback
        return self
    }
    
    /// Signals seek is cancelled because segment is missing.
    ///
    /// - parameter position: The possition where segment is missing
    @discardableResult
    public func onSegmentMissing(callback: @escaping (Int64) -> Void) -> CastChannel {
        onSegmentMissing = callback
        return self
    }
    
    /// Signals an error occured
    ///
    /// - parameter error: The error that occured
    @discardableResult
    public func onError(callback: @escaping (CastError) -> Void) -> CastChannel {
        onError = callback
        return self
    }
    
    /// `CastChannel` encountered a message it could not interpret.
    ///
    /// - parameter message: This is the raw `response` returned by the ChromeCast receiver
    /// - parameter error: The error trying to decode the message
    @discardableResult
    public func onUnsupportedMessage(callback: @escaping (String, Error) -> Void) -> CastChannel {
        onUnsupportedMessage = callback
        return self
    }
}


extension CastChannel {
    /// After joining a session, it might be necessary to request the constrols' status (volume level, timeshift enabled, tracks, startTimeLive). By sending this message to the receiver, it will then answer with updated controls.
    public func refreshControls() {
        
    }
}
extension CastChannel {
    /// Updates the currently displayed text track on the receiver
    ///
    /// - parameter textTrack: The track to display
    public func use(textTrack: Track) {
    }
    
    /// Updates the currently displayed text track on the receiver
    ///
    /// - parameter subtitle: The language code to display
    public func use(subtitle: String) {
        
    }
    
    /// Hides any subtiltes currently displayed
    public func hideSubtitles() {
        
    }
    
    /// Updates the currently active audio track on the receiver
    ///
    /// - parameter audioTrack: The track to display
    public func use(audioTrack: Track) {
    }
    
    /// Updates the currently active audio track on the receiver
    ///
    /// - parameter audio: The language code to display
    public func use(audio: String) {
        
    }
}

internal struct RawSingleValueEvent<Value: Decodable>: Decodable {
    internal let value: Value
    
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        value = try container.decode(Value.self, forKey: .data)
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
}

/// Embedded tracks are broadcasted to all connected senders when a sender send refreshcontrols message, or when subtitles/audio tracks change or period change. If the stream has multi periods the audio and text tracks can change even id's
public struct TracksUpdated: Decodable {
    /// All subtitle tracks available
    public let subtitles: [Track]
    
    /// All audio tracks available
    public let audio: [Track]
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let data = try container.nestedContainer(keyedBy: TracksInfoKeys.self, forKey: .data)
        let tracksInfo = try data.nestedContainer(keyedBy: TracksKeys.self, forKey: .tracksInfo)
        let activeTracksIds = try tracksInfo.decode([Int].self, forKey: .activeTrackIds)
        let tracks = try tracksInfo.decode([RawTrack].self, forKey: .tracks)
        subtitles = tracks
            .filter{ $0.type == "text" }
            .map{ Track(label: $0.label,
                        trackId: $0.trackId,
                        language: $0.language,
                        active: activeTracksIds.contains($0.trackId))
        }
        audio = tracks
            .filter{ $0.type == "audio" }
            .map{ Track(label: $0.label,
                        trackId: $0.trackId,
                        language: $0.language,
                        active: activeTracksIds.contains($0.trackId))
        }
    }
    
    internal struct RawTrack: Decodable {
        internal let label: String
        internal let type: String
        internal let trackId: Int
        internal let language: String
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
    internal enum TracksInfoKeys: CodingKey {
        case tracksInfo
    }
    internal enum TracksKeys: CodingKey {
        case activeTrackIds
        case tracks
    }
}


public struct Track {
    /// textual representation of track
    public let label: String
    
    /// Track identifier
    public let trackId: Int
    
    /// language identifier
    ///
    /// Format: sv
    public let language: String
    
    /// If the track is active or not
    public let active: Bool
}

public struct VolumeChanged: Decodable {
    /// The volume level
    public let volume: Int
    
    /// If the volume is muted or not
    public let muted: Bool
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        volume = try nested.decode(Int.self, forKey: .volume)
        muted = try nested.decode(Bool.self, forKey: .muted)
    }
    
    enum BaseKeys: CodingKey {
        case data
    }
    enum DataKeys: CodingKey {
        case volume
        case muted
    }
}

public struct CastError: Swift.Error, Decodable {
    /// The error code
    public let code: Int
    
    /// The error message
    public let message: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        code = try nested.decode(Int.self, forKey: .code)
        message = try nested.decode(String.self, forKey: .message)
    }
    
    enum BaseKeys: CodingKey {
        case data
    }
    enum DataKeys: CodingKey {
        case code
        case message
    }
}
