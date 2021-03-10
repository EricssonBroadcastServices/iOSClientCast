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

/* class CastEnvironmentSpec: QuickSpec {
    let url = "https://www.example.com"
    let customer = "Customer"
    let businessUnit = "BusinessUnit"
    let token = UUID().uuidString
    
    override func spec() {
        describe("JSON") {
            it("Should encode correctly") {
                let value = CastEnvironment(baseUrl: self.url, customer: self.customer, businessUnit: self.businessUnit, sessionToken: self.token).toJson
                
                
                expect(value["exposureApiURL"] as! String).to(equal(self.url))
                expect(value["customer"] as! String).to(equal(self.customer))
                expect(value["businessUnit"] as! String).to(equal(self.businessUnit))
                expect(value["sessionToken"] as! String).to(equal(self.token))
            }
            
            it("Should encode correctly") {
                let value = CastEnvironment(baseUrl: self.url, customer: self.customer, businessUnit: self.businessUnit, sessionToken: self.token)
                
                do {
                    let data = try JSONEncoder().encode(value)
                    
                    let decoded = try JSONDecoder().decode(CastEnvironment.self, from: data)
                    
                    expect(decoded.baseUrl).to(equal(self.url))
                    expect(decoded.customer).to(equal(self.customer))
                    expect(decoded.businessUnit).to(equal(self.businessUnit))
                    expect(decoded.sessionToken).to(equal(self.token))
                }
                catch {
                    expect(error).to(beNil())
                }
            }
        }
    }
} */
