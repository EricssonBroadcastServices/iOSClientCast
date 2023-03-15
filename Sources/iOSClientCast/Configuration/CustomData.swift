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
    
    /// EMP Customer Group identifier
    public let customer: String
    
    /// EMP Business Unit identifier
    public let businessUnit: String
    
    // language that should be used for mediainfo in control bar.
    public let locale: String?
    
    /// Client specific ad params that can be used in server side ad insertion
    public let adParameters: CastAdsOptions?
    
    /// Default subtitleLanguage to use when casting
    public let subtitleLanguage: String?
    
    /// Default audioLanguage to use when casting
    public let audioLanguage: String?
    
    /// X-Adobe-Primetime-MediaToken
    public let adobePrimetimeToken: String?
    
    /// If custom images should be used for the current playing asset.
    public let customImages: [CustomImage]?
    
    public init(customer: String, businessUnit: String,
                locale:String? = nil, adParameters: CastAdsOptions? = nil, adobePrimetimeToken: String? = nil, subtitleLanguage: String? = nil, audioLanguage: String? = nil, customImages: [CustomImage]? = nil   ) {
        self.customer = customer
        self.businessUnit = businessUnit
        self.locale = locale
        self.adParameters = adParameters
        self.adobePrimetimeToken = adobePrimetimeToken
        self.subtitleLanguage = subtitleLanguage
        self.audioLanguage = audioLanguage
        self.customImages = customImages
    }
}

extension CustomData {
    internal enum CodingKeys: String, CodingKey {
        case customer
        case businessUnit
        case locale
        case adParameters
        case adobePrimetimeToken
        case subtitleLanguage
        case audioLanguage
        case customImages
    }
}

extension CustomData {
    public var toJson: [String: Any] {
        var json = [String: Any]()
        json[CodingKeys.customer.rawValue] = customer
        json[CodingKeys.businessUnit.rawValue] = businessUnit
        if let locale = locale {
            json[CodingKeys.locale.rawValue] = locale
        }
        if let adParameters = adParameters {
            json[CodingKeys.adParameters.rawValue] = adParameters.toJson
        }
        if let adobePrimetimeToken = adobePrimetimeToken {
            json[CodingKeys.adobePrimetimeToken.rawValue] = adobePrimetimeToken
        }
        if let subtitleLanguage = subtitleLanguage {
            json[CodingKeys.subtitleLanguage.rawValue] = subtitleLanguage
        }
        if let audioLanguage = audioLanguage {
            json[CodingKeys.audioLanguage.rawValue] = audioLanguage
        }
        
        if let customImages = customImages {
            var convertedImageObjects:[Any] = []
            for customImage in customImages {
                convertedImageObjects.append(customImage.toJson)
            }
            json[CodingKeys.customImages.rawValue] = convertedImageObjects
        }
        return json
    }
}
