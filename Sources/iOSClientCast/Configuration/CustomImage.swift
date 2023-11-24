//
//  CustomImage.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-03-08.
//

import Foundation



/// Supported image types
public enum ImageType: String {
    case POSTER = "poster"
    case BANNER = "banner"
    case LOGO = "logo"
    case THUMBNAIL = "thumbnail"
    case COVER = "cover"
    case OTHER = "other"
}

/// Supported Image Orientations
public enum ImageOrientation: String {
    case Landscape = "landscape"
    case Portrait = "portrait"
}

/// Custom Image/s to use for the current playing asset.
///
///
/// * `url` custom image url
/// * `type`  ImageType.POSTER / ImageType.BANNER etc.
/// * `orientation` ImageOrientation.Landscape /  ImageOrientation.Portrait
/// * `height` image height
/// * `width` image width
/// * `tags`tags
/// 
public struct CustomImage: Codable {
    
    public let url: String
    public let type: String?
    public let orientation: String
    public let height: Int
    public let width: Int
    public let tags: [String]?
    
    public init(url: String, type: String? = nil ,
                orientation:String, height: Int, width: Int, tags: [String]? = nil) {
        self.url = url
        self.type = type
        self.orientation = orientation
        self.height = height
        self.width = width
        self.tags = tags
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encodeIfPresent(tags, forKey: .tags)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case url
        case type
        case orientation
        case height
        case width
        case tags
    }
    
    
    public var toJson: [String: Any] {
        var json = [String: Any]()
        
        json[CodingKeys.url.rawValue] = url
        json[CodingKeys.orientation.rawValue] = orientation
        json[CodingKeys.height.rawValue] = height
        json[CodingKeys.width.rawValue] = width
        
        
        if let type = type {
            json[CodingKeys.type.rawValue] = type
        }
        if let tags = tags {
            json[CodingKeys.tags.rawValue] = tags
        }
        return json
    }
}

