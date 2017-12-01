//
//  CustomData.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Data structure describing configuration options that can be delivered to the `ChromeCast` receiver during loading of new media.
public struct CustomData: Encodable {
    /// Environment used to contact exposure
    public let exposureEnvironment: CastEnvironment
    
    /// *Vod* media asset to cast
    public let assetId: String
    
    /// If provided on a live channel it specifies the program to watch otherwise the receiver will load the program live at the moment.
    public let programId: String?
    
    /// Specified audio language to use
    public let audioLanguage: String?
    
    /// Specified text language to use
    public let textLanguage: String?
    
    /// Specified audio language to use
    public let startTime: Int64?
    
    /// Dash stream used by Chromecast and HLS live stream used by mobile clients have different startTime and currentTime. To combat this, `absoluteStartTime` has been introduced for timeshifted live streams, which is a universal way to set start time.
    ///
    /// When taking back session, iOS and Android Chromecast senders can calculate the absoluteStartTime and start playback locally from that point.
    ///
    /// Should be specified in unix epoch time (ie milliseconds since 1970/01/01)
    ///
    /// Specifying `absoluteStartTime` to the chromecast receiver will override any settings made to `startTime` property (see above).
    ///
    /// - note: Only valid for *live* streaming.
    public let absoluteStartTime: Int64?
    
    /// Is timeshift enabled or disabled.
    ///
    /// - note: Only valid for *live* streaming.
    public let timeShiftDisabled: Bool
    
    /// Specify the maximum allowed bitrate
    public let maxBitrate: Int64?
    
    /// If the playback should start automatically
    public let autoplay: Bool
    
    /// Specify if SessionShift should be used or not.
    ///
    /// If enabled, playback will continue any bookmarked position related to the user (as specified by the `SessionToken`
    public let useLastViewedOffset: Bool
    
    public init(environment: CastEnvironment,
                assetId: String,
                programId: String? = nil,
                audioLanguage: String? = nil,
                textLanguage: String? = nil,
                startTime: Int64? = nil,
                absoluteStartTime: Int64? = nil,
                timeShiftDisabled: Bool = false,
                maxBitrate: Int64? = nil,
                autoplay: Bool = true,
                useLastViewedOffset: Bool = false) {
        self.exposureEnvironment = environment
        self.assetId = assetId
        self.programId = programId
        self.audioLanguage = audioLanguage
        self.textLanguage = textLanguage
        self.startTime = startTime
        self.absoluteStartTime = absoluteStartTime
        self.timeShiftDisabled = timeShiftDisabled
        self.maxBitrate = maxBitrate
        self.autoplay = autoplay
        self.useLastViewedOffset = useLastViewedOffset
    }
}

extension CustomData {
    internal enum CodingKeys: String, CodingKey {
        case exposureEnvironment = "ericssonexposure"
        case assetId
        case programId
        case audioLanguage
        case textLanguage
        case startTime
        case absoluteStartTime
        case timeShiftDisabled
        case maxBitrate
        case autoplay
        case useLastViewedOffset
    }
}

extension CustomData {
    public var toJson: [String: Any] {
        var json: [String: Any] = [
            CodingKeys.exposureEnvironment.rawValue: exposureEnvironment.toJson,
            CodingKeys.assetId.rawValue: assetId,
            CodingKeys.timeShiftDisabled.rawValue: timeShiftDisabled,
            CodingKeys.autoplay.rawValue: autoplay,
            CodingKeys.useLastViewedOffset.rawValue: useLastViewedOffset,
            ]
        
        if let value = audioLanguage {
            json[CodingKeys.audioLanguage.rawValue] = value
        }
        
        if let value = textLanguage {
            json[CodingKeys.textLanguage.rawValue] = value
        }
        
        if let value = startTime {
            json[CodingKeys.startTime.rawValue] = value
        }
        
        if let value = absoluteStartTime {
            json[CodingKeys.absoluteStartTime.rawValue] = value
        }
        
        if let value = maxBitrate {
            json[CodingKeys.maxBitrate.rawValue] = value
        }
        
        return json
    }
}
