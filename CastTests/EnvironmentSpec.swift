//
//  EnvironmentSpec.swift
//  CastTests
//
//  Created by Fredrik Sjöberg on 2017-12-06.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Cast

class EnvironmentSpec: QuickSpec {
    let url = "https://www.example.com"
    let customer = "Customer"
    let businessUnit = "BusinessUnit"
    let token = UUID().uuidString
    
    override func spec() {
        describe("JSON") {
            it("Should encode correctly") {
                let data = Environment(baseUrl: self.url, customer: self.customer, businessUnit: self.businessUnit, sessionToken: self.token).toJson
                
                
                expect(data["exposureApiURL"] as! String).to(equal(self.url))
                expect(data["customer"] as! String).to(equal(self.customer))
                expect(data["businessUnit"] as! String).to(equal(self.businessUnit))
                expect(data["sessionToken"] as! String).to(equal(self.token))
            }
        }
    }
}
