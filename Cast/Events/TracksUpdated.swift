//
//  TracksUpdated.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

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
                        trackId: $0.id,
                        language: $0.language,
                        active: activeTracksIds.contains($0.id))
        }
        audio = tracks
            .filter{ $0.type == "audio" }
            .map{ Track(label: $0.label,
                        trackId: $0.id,
                        language: $0.language,
                        active: activeTracksIds.contains($0.id))
        }
    }
    
    internal struct RawTrack: Decodable {
        internal let label: String
        internal let type: String
        internal let id: Int
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
