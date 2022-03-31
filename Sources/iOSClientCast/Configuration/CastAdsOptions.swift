//
//  CastAdsOptions.swift
//  Cast
//
//  Created by Udaya Sri Senarathne on 2021-03-09.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// Client / device specific information that can be used for ad targeting
///
/// * `latitude` provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
/// * `longitude` provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
/// * `mute` indicate whether player is muted or not
/// * `consent` a consent string passed from various Consent Management Platforms (CMP’s)
/// * `deviceMake` manufacturer of device such as Apple or Samsung
/// * `ifa` User device ID
/// * `gdprOptin` a flag for European Union traffic consenting to advertising
public struct CastAdsOptions:Codable {
    
    /// provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
    public let latitude: String?
    

    /// provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
    public let longitude: String?
    
    
    /// indicate whether player is muted or not
    public let mute: Bool?
    
    
    /// a consent string passed from various Consent Management Platforms (CMP’s)
    public let consent: String?
    
    
    /// manufacturer of device such as Apple or Samsung
    public let deviceMake: String?
    
    
    /// User device ID
    public let ifa: String?
    
    
    /// a flag for European Union traffic consenting to advertising
    public let gdprOptin: Bool?
    
    
    /// Specifies optional AdsOptions
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - mute: mute
    ///   - consent: consent
    ///   - deviceMake: deviceMake
    ///   - ifa: ifa
    ///   - gdprOptin: gdprOptin
    public init(latitude:String? = nil , longitude:String? = nil ,  mute:Bool? = nil , consent:String? = nil , deviceMake:String? = nil, ifa:String? = nil , gdprOptin:Bool? = nil ) {
        self.latitude = latitude
        self.longitude = longitude
        self.mute = mute
        self.consent = consent
        self.deviceMake = deviceMake
        self.ifa = ifa
        self.gdprOptin = gdprOptin
    }
    
    internal enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case mute
        case consent
        case deviceMake
        case ifa
        case gdprOptin
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(mute, forKey: .mute)
        try container.encode(consent, forKey: .consent)
        try container.encode(deviceMake, forKey: .deviceMake)
        try container.encode(ifa, forKey: .ifa)
        try container.encode(gdprOptin, forKey: .gdprOptin)
    }
    
    public var toJson: [String: Any] {
        
        var json = [String: Any]()
        if let latitude = latitude {
            json[CodingKeys.latitude.rawValue] = latitude
        }
        if let longitude = longitude {
            json[CodingKeys.longitude.rawValue] = longitude
        }
        
        if let mute = mute {
            json[CodingKeys.mute.rawValue] = mute
        }
        
        if let consent = consent {
            json[CodingKeys.consent.rawValue] = consent
        }
        
        if let deviceMake = deviceMake {
            json[CodingKeys.deviceMake.rawValue] = deviceMake
        }
        
        if let ifa = ifa {
            json[CodingKeys.ifa.rawValue] = ifa
        }
        
        if let gdprOptin = gdprOptin {
            json[CodingKeys.gdprOptin.rawValue] = gdprOptin
        }
        
        return json
    }
}
