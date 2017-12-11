//
//  ProgramChangedSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class ProgramChangedSpec: QuickSpec {
    static let programId = "aProgram"
    override func spec() {
        describe("Decoding") {
            
            it("Should decode correctly") {
                let data = ProgramChangedSpec.validJson()
                let program = data.decode(ProgramChanged.self)
                
                expect(program).toNot(beNil())
                expect(program!.programId).to(equal(ProgramChangedSpec.programId))
            }
            
            it("should fail decoding with missing key") {
                let data = ProgramChangedSpec.missingKeyJson()
                let program = data.decode(ProgramChanged.self)
                
                expect(program).to(beNil())
            }
        }
    }
    
    static func validJson() -> [String: Codable] {
        return [
            "data": [
                "programId": programId
            ]
        ]
    }
    
    static func missingKeyJson() -> [String: Codable] {
        return [
            "data": [
                "invalidKey": programId
            ]
        ]
    }
}
