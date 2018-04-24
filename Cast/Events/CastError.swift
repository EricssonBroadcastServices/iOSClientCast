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
public enum CastError: Error {
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
        
        /// `Cast.Chanbel` encountered a message it could not interpret because it was not formated as `utf8`.
        ///
        /// - parameter message: This is the raw `response` returned by the ChromeCast receiver
        case malformattedMessage(message: String)
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
            if let nested = try? container.nestedContainer(keyedBy: DataKeys.self, forKey: .data) {
                let errorCode = try nested.decodeIfPresent(Int.self, forKey: .code)
                let errorMessage = try nested.decodeIfPresent(String.self, forKey: .message)
                
                code = errorCode ?? -1
                message = errorMessage ?? "UNKNOWN_ERROR"
            }
            else {
                code = -1
                message = "UNKNOWN_ERROR"
            }
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
