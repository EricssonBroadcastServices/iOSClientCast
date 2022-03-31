//
//  MessageType.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Internal parsing of message types comming from the *EMP* receiver.
///
/// Each of these `MessageType`s correspond to an event delivered by the receiver that can be listened to through callback.
internal enum MessageType: String, Decodable {
    case tracksUpdated = "tracksupdated"
    case timeShiftEnabled = "timeShiftEnabled"
    case volumeChange = "volumechange"
    case durationChange = "durationchange"
    case startTimeLive = "startTimeLive"
    case programChanged = "programchanged"
    case segmentMissing = "segmentmissing"
    case autoplay = "autoplay"
    case isLive = "isLive"
    case error = "error"
    case entitlementChange = "entitlementchange"
    
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
