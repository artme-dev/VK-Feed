//
//  NewsFeedViewController.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject{
    func displayFeed(viewModel: NewsFeed.ShowPosts.ViewModel)
    func displayFeedContinuation(viewModel: NewsFeed.ShowPosts.ViewModel)
}

class NewsFeedViewController: UITableViewController {
        
    var interactor: NewsFeedBusinessLogic?
    private var revealedPostIds = Set<Int>()
    
    private var postsViewModel: [FeedCellViewModel]?
    private var cellHeights: [CellHeights]?
    
    private let tableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        return refreshControl
    }()
    
    private let footerView: TableFooterView = TableFooterView()
    
    private func setup(){
        let viewController = self
        let interactor = NewsFeedInteractor()
        let presenter = NewsFeedPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTableView()
        
        self.tableRefreshControl.beginRefreshing()
        self.tableRefreshControl.sendActions(for: .valueChanged)
    }
    
    private func configureTableView(){
        tableView.register(FeedTableViewCell.self,
                           forCellReuseIdentifier: FeedTableViewCell.reuseIdentifier)
        title = "Feed"
        tableView.allowsSelection = false
        tableView.backgroundColor = .vkBackground
        tableView.separatorStyle = .none
        tableView.addSubview(tableRefreshControl)
        
        tableView.tableFooterView = footerView
    }
    
    @objc private func refreshTableData(){
        interactor?.fetchFeed()
        revealedPostIds = Set<Int>()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsViewModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? FeedTableViewCell
        guard
            let posts = postsViewModel,
            let cellHeights = cellHeights,
            let feedCell = cell
        else{
            return UITableViewCell()
        }
        
        let postViewModel = posts[indexPath.row]
        let hasRevealingOption = cellHeights[indexPath.row].concealedCellHeight != nil
        let isRevealed = revealedPostIds.contains(postViewModel.postId)
    
        feedCell.configure(from: postViewModel, hasRevealingOption: !isRevealed && hasRevealingOption)
        feedCell.delegate = self
        return feedCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard
            let cellHeight = cellHeights?[indexPath.row],
            let postId = postsViewModel?[indexPath.row].postId
        else { return 0 }
        
        let isRevealedPost = revealedPostIds.contains(postId)
        
        if !isRevealedPost, let concealedCellHeight = cellHeight.concealedCellHeight {
            return concealedCellHeight
        } else {
            return cellHeight.revealedCellHeight
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentViewedContentHeight = scrollView.contentOffset.y + UIScreen.main.bounds.height
        let viewedContentHeightThreshold = tableView.contentSize.height
        
        if currentViewedContentHeight > viewedContentHeightThreshold{
            interactor?.addFeedContinuation()
        }
    }
}

extension NewsFeedViewController: NewsFeedDisplayLogic{
    func displayFeed(viewModel: NewsFeed.ShowPosts.ViewModel) {
        DispatchQueue.main.async {
            [weak self] in
            self?.footerView.isFeedEndFooter = !viewModel.hasContinuation
            self?.cellHeights = viewModel.cellHeights
            self?.postsViewModel = viewModel.postsModels
            self?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.tableRefreshControl.endRefreshing()
            }
        }
    }
    
    func displayFeedContinuation(viewModel: NewsFeed.ShowPosts.ViewModel) {
        DispatchQueue.main.async {
            [weak self] in
            self?.footerView.isFeedEndFooter = !viewModel.hasContinuation
            self?.cellHeights?.append(contentsOf: viewModel.cellHeights)
            self?.postsViewModel?.append(contentsOf: viewModel.postsModels)
            self?.tableView.reloadData()
        }
    }
}

extension NewsFeedViewController: TableViewCellDelegate{
    func revealContentView(postId: Int) {
        revealedPostIds.insert(postId)
        self.tableView.reloadData()
    }
}
