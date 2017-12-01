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
