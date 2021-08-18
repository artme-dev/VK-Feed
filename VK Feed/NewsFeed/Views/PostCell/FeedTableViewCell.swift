//
//  TableViewCell.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import UIKit

protocol FeedCellViewModel {
    var postId: Int { get }
    var dateInfo: String { get }
    var sourceName: String { get }
    var sourceImageUrl: String? { get }
    var textContent: String? { get }
    var likesCountInfo: String? { get }
    var commentsCountInfo: String? { get }
    var repostsCountInfo: String? { get }
    var viewsCountInfo: String? { get }
}

protocol TableViewCellDelegate: AnyObject {
    func revealContentView(postId: Int)
}

class FeedTableViewCell: UITableViewCell {
    
    struct Constants {
        static let postPaddings = UIEdgePaddings(top: 16, trailing: 0, bottom: 0, leading: 0)
        static let infoViewHeight: CGFloat = 62
        static let actionViewHeight: CGFloat = 48
        
        static let postPaddingsWidth = (postPaddings.trailing ?? 0) + (postPaddings.leading ?? 0)
        static let postPaddingsHeight = (postPaddings.top ?? 0) + (postPaddings.bottom ?? 0)
        static let textPaddingsWidth = PostContentView.Constants.textPaddingsWidth + postPaddingsWidth
        static let textPaddingsHeight = PostContentView.Constants.textPaddingsHeight
    }
    
    static let reuseIdentifier = "feedTableViewCell"
    private var postId: Int?
    weak var delegate: TableViewCellDelegate?
    
    private let postStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addBorder(to: .top, color: .vkBorder, thickness: 1)
        stackView.addBorder(to: .bottom, color: .vkBorder, thickness: 1)
        stackView.backgroundColor = .white
        
        stackView.contentMode = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let postInfoView: PostInfoView = {
        let infoView = PostInfoView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
    }()
    private let postContentView: PostContentView = {
        let contentView = PostContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    private let postActionsView: PostActionsView = {
        let actionView = PostActionsView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        return actionView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        postContentView.delegate = self
        
        contentView.addSubview(postStackView)
        postStackView.addArrangedSubview(postInfoView)
        postStackView.addArrangedSubview(postContentView)
        postStackView.addArrangedSubview(postActionsView)
        
        setConstraints()
    }
    
    func configure(from viewModel: FeedCellViewModel, hasRevealingOption: Bool){
        postId = viewModel.postId
        postInfoView.dateInfo = viewModel.dateInfo
        postInfoView.sourceName = viewModel.sourceName
        if let imageUrl = viewModel.sourceImageUrl {
            postInfoView.avatarImageURL = URL(string: imageUrl)
        }
        postContentView.setContent(text: viewModel.textContent, hasRevealingOption: hasRevealingOption)
        postActionsView.likesCountInfo = viewModel.likesCountInfo
        postActionsView.commentsCountInfo = viewModel.commentsCountInfo
        postActionsView.repostsCountInfo = viewModel.repostsCountInfo
        postActionsView.viewsCountInfo = viewModel.viewsCountInfo
    }
    
    private func setConstraints(){
        postStackView.fillSuperview(padding: Constants.postPaddings)
        postInfoView.heightAnchor.constraint(equalToConstant: Constants.infoViewHeight).isActive = true
        postActionsView.heightAnchor.constraint(equalToConstant: Constants.actionViewHeight).isActive = true
    }
    
    override func prepareForReuse() {
        postContentView.prepareForReuse()
        postInfoView.prepareForReuse()
    }
}

extension FeedTableViewCell: PostContentViewDelegate{
    func revealContentView() {
        guard let postId = postId else { return }
        delegate?.revealContentView(postId: postId)
    }
}
