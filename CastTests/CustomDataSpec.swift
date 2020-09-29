//
//  CustomDataSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class CustomDataSpec: QuickSpec {
    override func spec() {
        describe("JSON") {
            it("Should encode correctly") {
                let token = UUID().uuidString
                let environment = CastEnvironment(baseUrl: "https://www.example.com", customer: "Customer", businessUnit: "BusinessUnit", sessionToken: token)
                let data = CustomData(environment: environment,
                                      assetId: "assetId",
                                      programId: "programId",
                                      audioLanguage: "audioLang",
                                      textLanguage: "textLang",
                                      language: "language",
                                      startTime: 10,
                                      absoluteStartTime: 100,
                                      timeShiftDisabled: true,
                                      maxBitrate: 128,
                                      autoplay: false,
                                      useLastViewedOffset: true).toJson
                
                expect(data["ericssonexposure"]).toNot(beNil())
                
                expect(data["assetId"] as? String).to(equal("assetId"))
                expect(data["programId"] as? String).to(equal("programId"))
                expect(data["audioLanguage"] as? String).to(equal("audioLang"))
                expect(data["subtitleLanguage"] as? String).to(equal("textLang"))
                expect(data["language"] as? String).to(equal("language"))
                expect(data["startTime"] as? Int64).to(equal(10))
                expect(data["absoluteStartTime"] as? Int64).to(equal(100))
                expect(data["timeShiftDisabled"] as? Bool).to(equal(true))
                expect(data["maxBitrate"] as? Int64).to(equal(128))
                expect(data["autoplay"] as? Bool).to(equal(false))
                expect(data["useLastViewedOffset"] as? Bool).to(equal(true))
            }
        }
    }
}
