//
//  Dictionary+Extensions.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Codable {
    func decode<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Dictionary where Key == String, Value == Codable {
    func throwingDecode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
