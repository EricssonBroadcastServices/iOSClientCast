//
//  ValueChangedSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class VolumeChangedSpec: QuickSpec {
    static let volume = 101
    static let muted = false
    override func spec() {
        describe("Decoding") {
            
            it("Should decode correctly") {
                let data = VolumeChangedSpec.validJson()
                let value = data.decode(VolumeChanged.self)
                
                expect(value).toNot(beNil())
                expect(value!.volume).to(equal(VolumeChangedSpec.volume))
                expect(value!.muted).to(equal(VolumeChangedSpec.muted))
            }
            
            it("should faild decoding with missing key") {
                let data = VolumeChangedSpec.missingKeyJson()
                let value = data.decode(VolumeChanged.self)
                
                expect(value).to(beNil())
            }
        }
    }
    
    static func validJson() -> [String: Codable] {
        return [
            "data": [
                "volume": volume,
                "muted": muted
            ]
        ]
    }
    
    static func missingKeyJson() -> [String: Codable] {
        return [
            "data": [
                "volume": volume,
                "missingKey": muted
            ]
        ]
    }
}
