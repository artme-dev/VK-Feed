//
//  NewsFeedPresenter.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import UIKit

protocol NewsFeedPresentationLogic
{
    func presentPosts(response: NewsFeed.ShowPosts.Response)
    func addPosts(response: NewsFeed.ShowPosts.Response)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM 'at' HH:mm"
        return formatter
    }()
    
    func presentPosts(response wrappedResponse: NewsFeed.ShowPosts.Response){
        let response = wrappedResponse.response
        let viewModel = responseViewModel(from: response, hasContinuation: wrappedResponse.hasContinuation)
        viewController?.displayFeed(viewModel: viewModel)
    }
    
    func addPosts(response wrappedResponse: NewsFeed.ShowPosts.Response) {
        let response = wrappedResponse.response
        let viewModel = responseViewModel(from: response, hasContinuation: wrappedResponse.hasContinuation)
        viewController?.displayFeedContinuation(viewModel: viewModel)
    }
    
    private func responseViewModel(from response: VKFeedResponse, hasContinuation: Bool) -> NewsFeed.ShowPosts.ViewModel{
        let cellViewModels = response.items.map{ item in
            createPostViewModels(from: item, profiles: response.profiles, groups: response.groups)
        }
        let cellHeights = response.items.map{ item in
            CellHeightCalculator.cellHeights(text: item.text)
        }
        let viewModel = NewsFeed.ShowPosts.ViewModel(postsModels: cellViewModels,
                                                     cellHeights: cellHeights,
                                                     hasContinuation: hasContinuation)
        
        return viewModel
    }
    
    private func createPostViewModels(from item: VKFeedItem, profiles: [VKProfile], groups: [VKGroup]) -> NewsFeedCellViewModel{
        
        let source = sourceProfile(for: item.sourceId, profiles: profiles, groups: groups)
        
        let sourceName = source?.name ?? "Not found"
        let sourceImageUrl = source?.photo
        
        let date = Date(timeIntervalSince1970: TimeInterval(item.date))
        let formattedDateInfo = dateFormatter.string(from: date)
        
        let likesCountInfo = item.likes?.count
        let commentsCountInfo = item.comments?.count
        let repostsCountInfo = item.reposts?.count
        let viewsCountInfo = item.views?.count
        
        return NewsFeedCellViewModel(postId: item.postId,
                                     dateInfo: formattedDateInfo,
                                     sourceName: sourceName,
                                     sourceImageUrl: sourceImageUrl,
                                     textContent: item.text,
                                     likesCountInfo: prepareCountableItem(likesCountInfo),
                                     commentsCountInfo: prepareCountableItem(commentsCountInfo),
                                     repostsCountInfo: prepareCountableItem(repostsCountInfo),
                                     viewsCountInfo: prepareCountableItem(viewsCountInfo))
    }
    
    private func prepareCountableItem(_ count: Int?) -> String?{
        guard let count = count, count != 0 else { return nil }
        
        switch count {
        case 1_000 ..< 1_000_000:
            let value = Float(count) / 1_000.0
            return String(format: "%.1f", value) + "K"
        case let x where x > 1_000_000:
            let value = Float(count) / 1_000_000.0
            return String(format: "%.1f", value) + "M"
        default:
            return String(count)
        }
    }
    
    private func sourceProfile(for sourceId: Int, profiles: [VKProfile], groups: [VKGroup]) -> ProfileRepresentable?{
        let sources: [ProfileRepresentable] = sourceId > 0 ? profiles : groups
        let absoluteSourceId = abs(sourceId)
        let source = sources.first { item in
            return item.id == absoluteSourceId
        }
        return source
    }
}
