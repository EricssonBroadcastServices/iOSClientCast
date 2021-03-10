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
               
                
                let adParameters = CastAdsOptions(latitude: "latitude", longitude: "longitude", mute: true, consent: "consent", deviceMake: "apple", ifa: "ifa", gdprOptin: false)
                
                let data = CustomData(customer: "customer",
                                      businessUnit: "BusinessUnit",
                                      locale: "locale",
                                      adParameters: adParameters).toJson
                

                expect(data["customer"] as? String).to(equal("customer"))
                expect(data["BusinessUnit"] as? String).to(equal("BusinessUnit"))
                expect(data["locale"] as? String).to(equal("locale"))
                expect(data["adParameters"] as? CastAdsOptions).to(equal(adParameters))
            }
        }
    }
}
