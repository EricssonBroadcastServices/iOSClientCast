//
//  VolumeChanged.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Receiver message detailing a change in volume
public struct VolumeChanged: Decodable {
    /// The descrete volume
    @available(*, introduced: 0.73.0, deprecated: 2.0.82)
    public var volume: Int {
        return Int(volumeLevel * 100)
    }
    
    /// The volume level
    public let volumeLevel: Float
    
    /// If the volume is muted or not
    public let muted: Bool
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        let percent = try nested.decode(Float.self, forKey: .volume)
        volumeLevel = percent
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
