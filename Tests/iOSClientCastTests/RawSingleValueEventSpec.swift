//
//  RawSingleValueEventSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientCast

class RawSingleValueEventSpec: QuickSpec {
    override func spec() {
        describe("Decoding") {
            
            it("decodes String") {
                let input = "string"
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<String>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("decodes Bool") {
                let input = false
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<Bool>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("decodes Int") {
                let input = 10
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<Int>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("decodes Float") {
                let input: Float = 0.05
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<Float>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("decodes Double") {
                let input = 0.1
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<Double>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("decodes Int64") {
                let input:Int64 = 10
                let raw = RawSingleValueEventSpec.validJson(with: input).decode(RawSingleValueEvent<Int64>.self)
                
                expect(raw).toNot(beNil())
                expect(raw!.value).to(equal(input))
            }
            
            it("fails to decode with missing keys") {
                let input:Int64 = 10
                let raw = RawSingleValueEventSpec.missingKeyJson(with: input).decode(RawSingleValueEvent<Int64>.self)
                
                expect(raw).to(beNil())
            }
        }
    }
    
    static func validJson<T: Codable>(with value: T) -> [String: Codable] {
        return [
            "data": value
        ]
    }
    
    static func missingKeyJson<T: Codable>(with value: T) -> [String: Codable] {
        return [
            "invalidKey": value
        ]
    }
}
