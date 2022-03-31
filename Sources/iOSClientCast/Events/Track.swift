//
//  Track.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Describes an audio or text track.
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
