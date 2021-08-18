//
//  NewsFeedModels.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import UIKit

enum NewsFeed
{
    enum ShowPosts
    {
        struct Request { }
        
        struct Response{
            let response: VKFeedResponse
            let hasContinuation: Bool
        }
        struct ViewModel{
            let postsModels: [NewsFeedCellViewModel]
            let cellHeights: [CellHeights]
            let hasContinuation: Bool
        }
    }
}

struct NewsFeedCellViewModel: FeedCellViewModel{
    let postId: Int
    let dateInfo: String
    let sourceName: String
    let sourceImageUrl: String?
    let textContent: String?
    let likesCountInfo: String?
    var commentsCountInfo: String?
    let repostsCountInfo: String?
    let viewsCountInfo: String?
}
