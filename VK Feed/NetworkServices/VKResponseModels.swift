//
//  File.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import Foundation

struct VKFeedResponseWrapped: Decodable{
    let response: VKFeedResponse
}

struct VKFeedResponse: Decodable{
    let items: [VKFeedItem]
    let groups: [VKGroup]
    let profiles : [VKProfile]
    let nextFrom: String?
}

struct VKFeedItem: Decodable{
    let type: String
    let sourceId: Int
    let postId: Int
    let date: Int
    let text: String?
    let likes: VKCountableItem?
    let reposts: VKCountableItem?
    let comments: VKCountableItem?
    let views: VKCountableItem?
}

struct VKCountableItem: Decodable{
    let count: Int
}

protocol ProfileRepresentable{
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct VKProfile: Decodable, ProfileRepresentable{
    var id: Int
    var name: String
    var photo: String
    
    enum profileCodingKey: String, CodingKey {
        case id
        case firstName
        case lastName
        case photo = "photo100"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: profileCodingKey.self)
        id = try container.decode(Int.self, forKey: .id)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        name = "\(firstName) \(lastName)"
        photo = try container.decode(String.self, forKey: .photo)
    }
}

struct VKGroup: Decodable, ProfileRepresentable{
    let id: Int
    let name: String
    let photo: String
    
    enum profileCodingKey: String, CodingKey {
        case id
        case name
        case photo = "photo100"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: profileCodingKey.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        photo = try container.decode(String.self, forKey: .photo)
    }
}
