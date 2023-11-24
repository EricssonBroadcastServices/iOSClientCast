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

@testable import iOSClientCast

class CustomDataSpec: QuickSpec {
    override func spec() {
        describe("JSON") {
            it("Should encode correctly") {

                let adParameters = CastAdsOptions(latitude: "latitude", longitude: "longitude", mute: true, consent: "consent", deviceMake: "apple", ifa: "ifa", gdprOptin: true)
                
                let customImage = CustomImage(url: "https://sampleimage.jpeg", type: ImageType.BANNER.rawValue, orientation: ImageOrientation.Portrait.rawValue, height: 200, width: 300, tags: nil)
                
                let data = CustomData(customer: "customer",
                                      businessUnit: "businessUnit",
                                      locale: "locale",
                                      adParameters: adParameters,
                                      adobePrimetimeToken: "adobePrimetimeToken", subtitleLanguage: "en", audioLanguage: "fr", customImages: [customImage]).toJson
                

                expect(data["customer"] as? String).to(equal("customer"))
                expect(data["businessUnit"] as? String).to(equal("businessUnit"))
                expect(data["locale"] as? String).to(equal("locale"))
                expect(data["adobePrimetimeToken"] as? String).to(equal("adobePrimetimeToken"))
                expect(data["subtitleLanguage"] as? String).to(equal("en"))
                expect(data["audioLanguage"] as? String).to(equal("fr"))
            }
        }
    }
}
