//
//  CastEnvironment.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `CastEnvironment` defines the environment in which the receiver will request the proper media from the *Exposure api*.
///
/// If no media is found, `Cast.Channel` will respond with the appropriate error information.
public struct CastEnvironment: Codable {
    /// Base exposure url. This is the customer specific URL to Exposure
    public let baseUrl: String
    
    /// EMP Customer Group identifier
    public let customer: String
    
    /// EMP Business Unit identifier
    public let businessUnit: String
    
    /// Valid API session that has access to the requested media
    public let sessionToken: String
    
    public init(baseUrl: String, customer: String, businessUnit: String, sessionToken: String) {
        self.baseUrl = baseUrl
        self.customer = customer
        self.businessUnit = businessUnit
        self.sessionToken = sessionToken
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseUrl, forKey: .baseUrl)
        try container.encode(customer, forKey: .customer)
        try container.encode(businessUnit, forKey: .businessUnit)
        try container.encode(sessionToken, forKey: .sessionToken)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case baseUrl = "exposureApiURL"
        case customer
        case businessUnit
        case sessionToken
    }
    
    public var toJson: [String: Any] {
        return [
            CodingKeys.baseUrl.rawValue: baseUrl,
            CodingKeys.customer.rawValue: customer,
            CodingKeys.businessUnit.rawValue: businessUnit,
            CodingKeys.sessionToken.rawValue: sessionToken
        ]
    }
}
