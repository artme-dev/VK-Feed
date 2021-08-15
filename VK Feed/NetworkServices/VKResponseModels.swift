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
}

struct VKCountableItem: Decodable{
    let count: Int
}
