//
//  ChannelSenderSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation


import Quick
import Nimble

@testable import Cast
import GoogleCast

class MockedChannel: Channel {
    var messageReceived: (String) -> Void = { _ in }
    override func sendTextMessage(_ message: String, error: AutoreleasingUnsafeMutablePointer<GCKError?>?) -> Bool {
        messageReceived(message)
        return true
    }
}
class ChannelSenderSpec: QuickSpec {
    let channel = MockedChannel(namespace: "urn:x-cast:com.example.receiver")
    var message: String? = nil
    override func spec() {
        channel.messageReceived = { message in
            self.message = message
        }
        
        describe("Messages") {
            it("Should send refreshControls event") {
                self.channel.refreshControls()
                let targetMessage = self.refreshControlsMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
            
            it("Should send subtitles event") {
                self.channel.use(subtitle: "en")
                
                let targetMessage = self.useSubtitlesMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
            
            it("Should send textTrack event") {
                let track = Track(label: "label", trackId: 1, language: "sv", active: false)
                self.channel.use(textTrack: track)
                
                let targetMessage = self.useTextTrackMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
            
            
            it("Should send hideSubtitles event") {
                self.channel.hideSubtitles()
                
                let targetMessage = self.hideSubtitlesMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
            
            
            it("Should send audio selection event") {
                self.channel.use(audio: "en")
                
                let targetMessage = self.useAudioMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
            
            it("Should send audioTrackc event") {
                let track = Track(label: "label", trackId: 1, language: "sv", active: false)
                self.channel.use(audioTrack: track)
                
                let targetMessage = self.useAudioTrackMessage()
                expect(targetMessage).toNot(beNil())
                expect(self.message).toNot(beNil())
                expect(self.message).to(equal(targetMessage!))
            }
        }
    }
    
    func refreshControlsMessage() -> String? {
        return """
        {"type":"refreshcontrols"}
        """
    }
    
    func useSubtitlesMessage() -> String? {
        return """
        {"type":"showtexttrack","data":{"language":"en"}}
        """
    }
    
    func useTextTrackMessage() -> String? {
        return """
        {"type":"showtexttrack","data":{"language":"sv"}}
        """
    }
    
    func hideSubtitlesMessage() -> String? {
        return """
        {"type":"hidetexttrack"}
        """
    }
    
    func useAudioMessage() -> String? {
        return """
        {"type":"enableaudiotrack","data":{"language":"en"}}
        """
    }
    
    func useAudioTrackMessage() -> String? {
        return """
        {"type":"enableaudiotrack","data":{"language":"sv"}}
        """
    }
}
