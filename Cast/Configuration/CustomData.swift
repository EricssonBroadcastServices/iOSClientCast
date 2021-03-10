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
    
    public let adParameters: CastAdsOptions?
    
    public init(customer: String, businessUnit: String,
                locale:String? = nil, adParameters: CastAdsOptions? = nil) {
        self.customer = customer
        self.businessUnit = businessUnit
        self.locale = locale
        self.adParameters = adParameters
       
    }
}

extension CustomData {
    internal enum CodingKeys: String, CodingKey {
        case customer
        case businessUnit
        case locale
        case adParameters
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
        return json
    }
}
