//
//  CastChannel.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-11-30.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import GoogleCast

class CastChannel {
    let gckCastChannel: GCKCastChannel
    
    init(namepace: String) {
        gckCastChannel = GCKCastChannel(namespace: namepace)
    }
}
