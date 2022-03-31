//
//  RawSingleValueEvent.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Internal response struct for parsing single value event data
internal struct RawSingleValueEvent<Value: Decodable>: Decodable {
    internal let value: Value
    
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        value = try container.decode(Value.self, forKey: .data)
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
}
