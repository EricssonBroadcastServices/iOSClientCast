//
//  ChannelSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class ChannelSpec: QuickSpec {
    let channel = Channel(namespace: "urn:x-cast:com.example.receiver")
    var tracksUpdated: TracksUpdated? = nil
    var timeShift: Bool? = nil
    var volume: VolumeChanged? = nil
    var duration: Float? = nil
    var startTimeLive: Int64? = nil
    var program: String? = nil
    var segment: Int64? = nil
    var autoplay: Bool? = nil
    var live: Bool? = nil
    var error: CastError? = nil
    
    override func spec() {
        channel
            .onTracksUpdated { tracksUpdated in
                self.tracksUpdated = tracksUpdated
            }
            .onTimeshiftEnabled{ timeshift in
                self.timeShift = timeshift
            }
            .onVolumeChanged { volumeChanged in
                self.volume = volumeChanged
            }
            .onDurationChanged { duration in
                self.duration = duration
            }
            .onStartTimeLive{ startTime in
                self.startTimeLive = startTime
            }
            .onProgramChanged{ program in
                self.program = program
            }
            .onSegmentMissing{ segment in
                self.segment = segment
            }
            .onAutoplay { autoplay in
                self.autoplay = autoplay
            }
            .onIsLive { isLive in
                self.live = isLive
            }
            .onError{ error in
                self.error = error
        }
        
        describe("Init") {
            it("Should init with namespace correctly") {
                expect(self.channel.protocolNamespace).to(equal("urn:x-cast:com.example.receiver"))
            }
        }
        
        describe("Events") {
            it("Forward onTracksUpdated event") {
                let message = self.tracksMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.tracksUpdated).toNot(beNil())
            }
            
            it("Forward onTimeshiftEnabled event") {
                let message = self.timeshiftMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.timeShift).toNot(beNil())
            }
            
            it("Forward onVolumeChanged event") {
                let message = self.volumeMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.volume).toNot(beNil())
            }
            
            it("Forward onDurationChanged event") {
                let message = self.durationMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.duration).toNot(beNil())
            }
            
            it("Forward onStartTimeLive event") {
                let message = self.startTimeLiveMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.startTimeLive).toNot(beNil())
            }
            
            it("Forward onProgramChanged event") {
                let message = self.programMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.program).toNot(beNil())
            }
            
            it("Forward onSegmentMissing event") {
                let message = self.segmentMissingMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.segment).toNot(beNil())
            }
            
            it("Forward onAutoplay event") {
                let message = self.autoplayMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.autoplay).toNot(beNil())
            }
            
            it("Forward onIsLive event") {
                let message = self.liveMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.live).toNot(beNil())
            }
            
            it("Forward onError event") {
                let message = self.errorMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                
                expect(self.error).toNot(beNil())
            }
            
            it("Should forward unsupported messages") {
                let message = self.unsupportedMessage()
                expect(message).toNot(beNil())
                self.channel.didReceiveTextMessage(message!)
                expect(self.error).toNot(beNil())
                switch self.error! {
                case .sender(reason: let reason):
                    switch reason {
                    case .unsupportedMessage(message: let receivedMessage, error: let receivedError):
                        expect(receivedMessage).to(equal(message))
                    default:
                        expect("To receive SenderError.unsupportedMessage").to(equal(self.error!.localizedDescription))
                    }
                default:
                    expect("To receive SenderError").to(equal(self.error!.localizedDescription))
                }
            }
        }
    }
    
    func tracksMessage() -> String? {
        var data: [String: Codable] = TracksUpdatedSpec.validJson()
        data["type"] = "tracksupdated"
        return data.jsonMessage()
    }
    
    func timeshiftMessage() -> String? {
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: false)
        data["type"] = "timeShiftEnabled"
        return data.jsonMessage()
    }
    
    func volumeMessage() -> String? {
        var data: [String: Codable] = VolumeChangedSpec.validJson()
        data["type"] = "volumechange"
        return data.jsonMessage()
    }
    
    func durationMessage() -> String? {
        let input: Float = 10
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: input)
        data["type"] = "durationchange"
        return data.jsonMessage()
    }
    
    func startTimeLiveMessage() -> String? {
        let input: Int64 = 10
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: input)
        data["type"] = "startTimeLive"
        return data.jsonMessage()
    }
    
    func programMessage() -> String? {
        var data: [String: Codable] = ProgramChangedSpec.validJson()
        data["type"] = "programchanged"
        return data.jsonMessage()
    }
    
    func segmentMissingMessage() -> String? {
        let input: Int64 = 10
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: input)
        data["type"] = "segmentmissing"
        return data.jsonMessage()
    }
    
    func autoplayMessage() -> String? {
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: false)
        data["type"] = "autoplay"
        return data.jsonMessage()
    }
    
    func liveMessage() -> String? {
        var data: [String: Codable] = RawSingleValueEventSpec.validJson(with: false)
        data["type"] = "isLive"
        return data.jsonMessage()
    }
    
    func errorMessage() -> String? {
        var data: [String: Codable] = CastErrorSpec.validJson()
        data["type"] = "error"
        return data.jsonMessage()
    }
    
    func unsupportedMessage() -> String? {
        var data: [String: Codable] = [
            "type": "unknownAction",
            "data": "someData"
        ]
        return data.jsonMessage()
    }
}
