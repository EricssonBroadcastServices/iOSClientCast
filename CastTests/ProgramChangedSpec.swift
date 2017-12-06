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
    let programId = "aProgram"
    override func spec() {
        describe("Decoding") {
            
            it("Should decode correctly") {
                let data = self.validJson()
                let program = data.decode(ProgramChanged.self)
                
                expect(program).toNot(beNil())
                expect(program!.programId).to(equal(self.programId))
            }
            
            it("should faild decoding with missing key") {
                let data = self.missingKeyJson()
                let program = data.decode(ProgramChanged.self)
                
                expect(program).to(beNil())
            }
        }
    }
    
    func validJson() -> [String: Codable] {
        return [
            "data": [
                "programId": programId
            ]
        ]
    }
    
    func missingKeyJson() -> [String: Codable] {
        return [
            "data": [
                "invalidKey": programId
            ]
        ]
    }
}
