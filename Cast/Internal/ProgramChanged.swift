//
//  ProgramChanged.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation


/// Internal struct used to parse receiver message detailing a change in program
internal struct ProgramChanged: Decodable {
    let programId: String
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseKeys.self)
        let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let program = try nested.nestedContainer(keyedBy: ProgramKeys.self, forKey: .program)
        programId = try program.decode(String.self, forKey: .programId)
    }
    
    internal enum BaseKeys: CodingKey {
        case data
    }
    
    internal enum DataKeys: CodingKey {
        case program
    }
    
    internal enum ProgramKeys: String, CodingKey {
        case programId
    }
}
