//
//  CastErrorSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class CastErrorSpec: QuickSpec {
    static let code = 101
    static let message = "message"
    override func spec() {
        describe("Decoding ReceiverError") {
            
            it("Should decode correctly") {
                let data = CastErrorSpec.validJson()
                let value = data.decode(CastError.ReceiverError.self)
                
                expect(value).toNot(beNil())
                expect(value!.code).to(equal(CastErrorSpec.code))
                expect(value!.message).to(equal(CastErrorSpec.message))
            }
            
            it("should faild decoding with missing key") {
                let data = CastErrorSpec.missingKeyJson()
                let value = data.decode(CastError.ReceiverError.self)
                
                expect(value).to(beNil())
            }
        }
    }
    
    static func validJson() -> [String: Codable] {
        return [
            "data": [
                "code": code,
                "message": message
            ]
        ]
    }
    
    static func missingKeyJson() -> [String: Codable] {
        return [
            "data": [
                "code": code,
                "missingKeys": message
            ]
        ]
    }
}
