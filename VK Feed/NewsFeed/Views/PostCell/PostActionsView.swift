//
//  PostActionsView.swift
//  VK Feed
//
//  Created by Артём on 13.08.2021.
//

import UIKit

class PostActionsView: UIView {
    
    struct Constants{
        static let likeImageName = "likes"
        static let commentsImageName = "comments"
        static let repostsImageName = "reposts"
        static let viewsImageName = "views"
        
        static let viewsCountFontSize: CGFloat = 15
        
        static let actionStackPaddings = UIEdgePaddings(top: 0, trailing: nil, bottom: 0, leading: 8)
        static let viewsCountStackPaddings = UIEdgePaddings(top: 0, trailing: 16, bottom: 0, leading: nil)
        static let actionsStackSpacing: CGFloat = 8
        static let viewsInfoStackSpacing: CGFloat = 2
    }
    
    private let likesButton: PostActionButton = {
        let likesButton = PostActionButton()
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        likesButton.setContentImage(named: Constants.likeImageName)
        return likesButton
    }()
    var likesCountInfo: String?{
        get { return likesButton.contentTitle }
        set { likesButton.contentTitle = newValue}
    }
    
    private let commentsButton: PostActionButton = {
        let commentsButton = PostActionButton()
        commentsButton.translatesAutoresizingMaskIntoConstraints = false
        commentsButton.setContentImage(named: Constants.commentsImageName)
        return commentsButton
    }()
    var commentsCountInfo: String?{
        get { return commentsButton.contentTitle }
        set { commentsButton.contentTitle = newValue}
    }
    
    private let repostsButton: PostActionButton = {
        let repostsButton = PostActionButton()
        repostsButton.translatesAutoresizingMaskIntoConstraints = false
        repostsButton.setContentImage(named: Constants.repostsImageName)
        return repostsButton
    }()
    var repostsCountInfo: String?{
        get { return repostsButton.contentTitle }
        set { repostsButton.contentTitle = newValue}
    }
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.viewsCountFontSize)
        label.textColor = .vkElement
        return label
    }()
    var viewsCountInfo: String?{
        get { return viewsCountLabel.text }
        set { viewsCountLabel.text = newValue }
    }
    
    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Constants.actionsStackSpacing
        
        stack.addArrangedSubview(likesButton)
        stack.addArrangedSubview(commentsButton)
        stack.addArrangedSubview(repostsButton)
        return stack
    }()
    
    private lazy var viewsCountStack: UIStackView = {
        let contentStack = UIStackView()
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.spacing = Constants.viewsInfoStackSpacing
        
        let iconImage = UIImage(named: Constants.viewsImageName)
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(viewsCountLabel)
        return contentStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(){
        addSubview(actionsStack)
        actionsStack.fillSuperview(padding: Constants.actionStackPaddings)
        
        addSubview(viewsCountStack)
        viewsCountStack.fillSuperview(padding: Constants.viewsCountStackPaddings)
    }
}
