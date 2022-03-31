//
//  ProgramUpdated.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2018-03-12.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public struct ProgramUpdated: Codable {
    /// The id of the program.
    public let programId: String
    
    /// The id of the asset this program is for.
    public let assetId: String
    
    /// The id of the channel this program is on.
    public let channelId: String
    
    /// Start time for the program
    public let startTime: String?
    
    /// End time for the program
    public let endTime: String?
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let program = try nested.nestedContainer(keyedBy: ProgramKeys.self, forKey: .program)
        programId = try program.decode(String.self, forKey: .programId)
        assetId = try program.decode(String.self, forKey: .assetId)
        channelId = try program.decode(String.self, forKey: .channelId)
        startTime = try program.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try program.decodeIfPresent(String.self, forKey: .endTime)
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
    
    internal enum DataKeys: CodingKey {
        case program
    }
    
    internal enum ProgramKeys: String, CodingKey {
        case programId
        case assetId
        case channelId
        case startTime
        case endTime
    }
}
