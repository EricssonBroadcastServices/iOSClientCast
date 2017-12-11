//
//  TracksUpdatedSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class TracksUpdatedSpec: QuickSpec {
    let volume = 101
    let muted = false
    override func spec() {
        describe("Decoding") {
            
            it("Should decode correctly") {
                let data = TracksUpdatedSpec.validJson()
                let value = data.decode(TracksUpdated.self)
                
                expect(value).toNot(beNil())
                expect(value!.subtitles.count).to(equal(2))
                expect(value!.subtitles[0].label).to(equal("Subs"))
                expect(value!.subtitles[0].trackId).to(equal(1))
                expect(value!.subtitles[0].language).to(equal("en"))
                expect(value!.subtitles[0].active).to(equal(true))
                
                expect(value!.subtitles[1].active).to(equal(false))
                
                expect(value!.audio.count).to(equal(1))
                expect(value!.audio[0].label).to(equal("Audio"))
                expect(value!.audio[0].trackId).to(equal(3))
                expect(value!.audio[0].language).to(equal("en"))
                expect(value!.audio[0].active).to(equal(true))
            }
            
            it("should fail decoding with missing key") {
                let data = TracksUpdatedSpec.missingKeyJson()
                let value = data.decode(VolumeChanged.self)
                
                expect(value).to(beNil())
            }
        }
    }
    
    static func validJson() -> [String: Codable] {
        return [
            "data": [
                "tracksInfo": [
                    "activeTrackIds": [1, 3],
                    "tracks": [
                        [
                            "label":"Subs",
                            "type":"text",
                            "id":1,
                            "language":"en"
                        ],
                        [
                            "label":"Swedish",
                            "type":"text",
                            "id":2,
                            "language":"sv"
                        ],
                        [
                            "label":"Audio",
                            "type":"audio",
                            "id":3,
                            "language":"en"
                        ]
                    ]
                ]
            ]
        ]
    }
    
    static func missingKeyJson() -> [String: Codable] {
        return [
            "data": [
                "tracksInfo": [
                    "activeTrackIds": [1, 2],
                    "tracks": [
                        [
                            "label":"Subs",
                            "type":"text",
                            "id":1,
                            "language":"en"
                        ],
                        [
                            "label":"Audio",
                            "type":"audio",
                            "id":2,
                            "language":"en"
                        ]
                    ]
                ]
            ]
        ]
    }
}

