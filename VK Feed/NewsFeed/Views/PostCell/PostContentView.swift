//
//  PostContentView.swift
//  VK Feed
//
//  Created by Артём on 11.08.2021.
//

import UIKit

protocol PostContentViewDelegate: AnyObject {
    func revealContentView()
}

class PostContentView: UIView {
    
    struct Constants {
        static let textPaddings = UIEdgePaddings(top: 0, trailing: 12, bottom: nil, leading: 12)
        static let bottomTextPadding: CGFloat = 4
        static let textFont: UIFont = .systemFont(ofSize: 15)
        
        static let textPaddingsWidth = (textPaddings.trailing ?? 0) + (textPaddings.leading ?? 0)
        static let textPaddingsHeight = (textPaddings.top ?? 0) + (textPaddings.bottom ?? 0) + bottomTextPadding
        
        static let concealedTextLinesCount = 6
        static let concealingTextMinLinesCount = 10
        static let revealingButtonTitle = "Show More"
        static let revealingButtonPaddings = UIEdgePaddings(top: nil, trailing: 12, bottom: 0, leading: 12)
        static let buttonTitleFont: UIFont = .systemFont(ofSize: 15, weight: .medium)
        static let buttonHeight: CGFloat = 24
    }
    
    weak var delegate: PostContentViewDelegate?
    
    private let revealingTextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.revealingButtonTitle, for: .normal)
        button.setTitleColor(.vkBrand, for: .normal)
        button.titleLabel?.font = Constants.buttonTitleFont
        button.contentHorizontalAlignment = .left
        button.isHidden = true
        return button
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.font = Constants.textFont
        
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        textView.dataDetectorTypes = .all
        
        return textView
    }()
    func setContent(text: String?, hasRevealingOption: Bool){
        contentTextView.text = text
        contentTextView.textContainer.maximumNumberOfLines = 0
        
        if hasRevealingOption{
            contentTextView.textContainer.maximumNumberOfLines = Constants.concealedTextLinesCount
            revealingTextButton.isHidden = false
        }
    }
    
    func prepareForReuse(){
        contentTextView.text = nil
        removeRevealingOption()
    }
    
    func removeRevealingOption(){
        contentTextView.textContainer.maximumNumberOfLines = 0
        revealingTextButton.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        addSubview(contentTextView)
        addSubview(revealingTextButton)
        contentTextView.fillSuperview(padding: Constants.textPaddings)
        revealingTextButton.fillSuperview(padding: Constants.revealingButtonPaddings)
        revealingTextButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        
        revealingTextButton.addTarget(self, action: #selector(revealText), for: .touchUpInside)
    }
    
    @objc private func revealText(){
        removeRevealingOption()
        delegate?.revealContentView()
    }
}
