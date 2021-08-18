//
//  PostInfoView.swift
//  VK Feed
//
//  Created by Артём on 11.08.2021.
//

import UIKit

class PostInfoView: UIView {
    
    struct Constants {
        static let sourceNameFontSize: CGFloat = 16
        static let dateInfoFontSize: CGFloat = 14
        static let infoStackPaddings = UIEdgePaddings(top: 4, trailing: nil, bottom: 4, leading: nil)
        static let leftInfoPadding: CGFloat = 8
        static let contentPaddings = UIEdgePaddings(top: 8, trailing: 0, bottom: 8, leading: 8)
    }
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let avatarImageView: UIRoundImageView = {
        let imageView = UIRoundImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var currentAvatarImageURL: URL?
    var avatarImageURL: URL? {
        set{
            currentAvatarImageURL = newValue
            avatarImageView.load(from: newValue)
        }
        get{ return currentAvatarImageURL }
    }
    
    private let sourceNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: Constants.sourceNameFontSize)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    var sourceName: String? {
        set{ sourceNameLabel.text = newValue }
        get{ sourceNameLabel.text }
    }
    
    private let dateInfoLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: Constants.dateInfoFontSize)
        dateLabel.textColor = .vkElement
        return dateLabel
    }()
    var dateInfo: String? {
        set{ dateInfoLabel.text = newValue }
        get{ return dateInfoLabel.text }
    }
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
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
        addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(sourceNameLabel)
        infoStackView.addArrangedSubview(dateInfoLabel)
        
        setConstraints()
    }
    
    private func setAvatarConstraints(){
        avatarImageView.fillSuperview(padding: UIEdgePaddings(top: .zero, trailing: nil, bottom: .zero, leading: nil))
        avatarImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    private func setInfoConstraints(){
        infoStackView.fillSuperview(padding: Constants.infoStackPaddings)
        infoStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.leftInfoPadding).isActive = true
    }
    
    private func setConstraints() {
        contentView.fillSuperview(padding: Constants.contentPaddings)
        setAvatarConstraints()
        setInfoConstraints()
    }
    
    func prepareForReuse(){
        avatarImageView.image = nil
    }
}
