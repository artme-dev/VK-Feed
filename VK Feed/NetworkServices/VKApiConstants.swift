//
//  VkAPI.swift
//  VK Feed
//
//  Created by Артём on 08.08.2021.
//

import Foundation

struct VKApiConstants{
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    
    struct Paths{
        static let feed = "/method/newsfeed.get"
    }
}
