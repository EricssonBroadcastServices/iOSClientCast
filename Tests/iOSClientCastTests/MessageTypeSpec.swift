//
//  MessageTypeSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientCast

class MessageTypeSpec: QuickSpec {
    override func spec() {
        describe("Decoding") {
            it("should decode tracksupdated") {
                let messageType = self.validJson(with: "tracksupdated").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.tracksUpdated))
            }
            
            it("should decode timeShiftEnabled") {
                let messageType = self.validJson(with: "timeShiftEnabled").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.timeShiftEnabled))
            }
            
            it("should decode volumeChange") {
                let messageType = self.validJson(with: "volumechange").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.volumeChange))
            }
            
            it("should decode durationChange") {
                let messageType = self.validJson(with: "durationchange").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.durationChange))
            }
            
            it("should decode startTimeLive") {
                let messageType = self.validJson(with: "startTimeLive").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.startTimeLive))
            }
            
            it("should decode programChanged") {
                let messageType = self.validJson(with: "programchanged").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.programChanged))
            }
            
            it("should decode autoplay") {
                let messageType = self.validJson(with: "autoplay").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.autoplay))
            }
            
            it("should decode isLive") {
                let messageType = self.validJson(with: "isLive").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.isLive))
            }
            
            it("should decode error") {
                let messageType = self.validJson(with: "error").decode(MessageType.self)
                expect(messageType).to(equal(MessageType.error))
            }
            
            it("should fail with missing keys") {
                let messageType = self.missingKeyJson(with: "error").decode(MessageType.self)
                expect(messageType).to(beNil())
            }
            
            it("should fail with undefined messageType") {
                let messageType = self.validJson(with: "undefined").decode(MessageType.self)
                expect(messageType).to(beNil())
            }
        }
    }
    
    
    func validJson(with value: String) -> [String: Codable] {
        return [
            "type": value
        ]
    }
    
    func missingKeyJson(with value: String) -> [String: Codable] {
        return [
            "missingKeys": value
        ]
    }
}
