//
//  CastError.swift
//  Cast
//
//  Created by Fredrik Sjöberg on 2017-12-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import GoogleCast

/// Error message for the `Cast` framework
public enum CastError {
    case receiver(reason: ReceiverError)
    case sender(reason: SenderError)
    case googleCast(error: GCKError)
    
    /// Sender errors occur when the `Cast` framework attempts communication with the `ChromeCast` receiver.
    public enum SenderError: Error {
        /// `Cast.Channel` failed to serialize the outgoing message.
        ///
        /// - parameter error: The error trying to decode the message
        /// - parameter type: The type of message that failed
        case failedToSerializeMessage(error: Error, type: String)
        
        /// `Cast.Channel` encountered a message it could not interpret.
        ///
        /// - parameter message: This is the raw `response` returned by the ChromeCast receiver
        /// - parameter error: The error trying to decode the message
        case unsupportedMessage(message: String, error: Error)
    }
    
    /// Receiver errors are delivered by the `ChromeCast` receiver to the `Cast` framework.
    public struct ReceiverError: Swift.Error, Decodable {
        /// The error code
        public let code: Int
        
        /// The error message
        public let message: String
        
        internal init(code: Int, message: String) {
            self.code = code
            self.message = message
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: BaseKeys.self)
            let nested = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
            
            code = try nested.decode(Int.self, forKey: .code)
            message = try nested.decode(String.self, forKey: .message)
        }
        
        internal enum BaseKeys: CodingKey {
            case data
        }
        internal enum DataKeys: CodingKey {
            case code
            case message
        }
    }
}
