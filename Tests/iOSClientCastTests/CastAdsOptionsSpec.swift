//
//  CastAdsOptionsSpec.swift
//  CastTests
//
//  Created by Udaya Sri Senarathne on 2021-03-10.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import iOSClientCast
class CastAdsOptionsSpec: QuickSpec {
    
    let latitude = "latitude"
    let longitude = "longitude"
    let mute = true
    let consent = "consent"
    let deviceMake = "apple"
    let ifa = "ifa"
    let gdprOptin = true
    
    
    
    override func spec() {
        describe("JSON") {
            it("Should encode correctly") {
                let adParameters = CastAdsOptions(latitude:self.latitude, longitude: self.longitude, mute: self.mute, consent: self.consent, deviceMake: self.deviceMake, ifa: self.ifa, gdprOptin: self.gdprOptin)

                do {
                    let data = try JSONEncoder().encode(adParameters)

                    let decoded = try JSONDecoder().decode(CastAdsOptions.self, from: data)

                    expect(decoded.latitude).to(equal(self.latitude))
                    expect(decoded.longitude).to(equal(self.longitude))
                    expect(decoded.mute).to(equal(self.mute))
                    expect(decoded.consent).to(equal(self.consent))
                    expect(decoded.deviceMake).to(equal(self.deviceMake))
                    expect(decoded.ifa).to(equal(self.ifa))
                    expect(decoded.gdprOptin).to(equal(self.gdprOptin))
                }
                catch {
                    expect(error).to(beNil())
                }
            }
        }
    }
}
