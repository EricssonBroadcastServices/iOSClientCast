//
//  EntitlementChange.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2018-03-12.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public struct EntitlementChange: Decodable {
    
    /// If this is a live entitlement.
    public let live: Bool
    
    /// If fast forward is enabled
    public let ffEnabled: Bool
    
    /// If timeshift is disabled
    public let timeshiftEnabled: Bool
    
    /// If rewind is enabled
    public let rwEnabled: Bool
    
    /// If airplay is blocked
    public let airplayBlocked: Bool
    
    /// Min bitrate to use
    public let minBitrate: Int64?
    
    /// Max bitrate to use
    public let maxBitrate: Int64?
    
    /// Max height resolution
    public let maxResHeight: Int?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let entitlement = try nested.nestedContainer(keyedBy: ProgramKeys.self, forKey: .entitlement)
        live = try entitlement.decode(Bool.self, forKey: .live)
        ffEnabled = try entitlement.decode(Bool.self, forKey: .ffEnabled)
        timeshiftEnabled = try entitlement.decode(Bool.self, forKey: .timeshiftEnabled)
        rwEnabled = try entitlement.decode(Bool.self, forKey: .rwEnabled)
        airplayBlocked = try entitlement.decode(Bool.self, forKey: .airplayBlocked)
        minBitrate = try entitlement.decodeIfPresent(Int64.self, forKey: .minBitrate)
        maxBitrate = try entitlement.decodeIfPresent(Int64.self, forKey: .maxBitrate)
        maxResHeight = try entitlement.decodeIfPresent(Int.self, forKey: .maxResHeight)
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
    
    internal enum DataKeys: CodingKey {
        case entitlement
    }
    
    internal enum ProgramKeys: String, CodingKey {
        case live
        case ffEnabled
        case timeshiftEnabled
        case rwEnabled
        case airplayBlocked
        case minBitrate
        case maxBitrate
        case maxResHeight
    }
}
