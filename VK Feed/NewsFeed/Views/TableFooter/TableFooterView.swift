//
//  TableFooterView.swift
//  VK Feed
//
//  Created by Артём on 18.08.2021.
//

import UIKit

class TableFooterView: UIView {
    
    struct Constants{
        static let loadMoreLabelText = "Swipe up to load more"
        static let endFooterLabelText = "All posts"
        static let labelFont: UIFont = .systemFont(ofSize: 15)
        static let footerHeight: CGFloat = 48
    }

    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isFeedEndFooter: Bool = false{
        didSet {
            isHidden = false
            if self.isFeedEndFooter{
                self.label.text = Constants.endFooterLabelText
            } else {
                self.label.text = Constants.loadMoreLabelText
            }
        }
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.labelFont
        label.textColor = .vkElement
        return label
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
        contentView.addSubview(label)
    
        frame.size.height = Constants.footerHeight
        setConstraints()
        
        isHidden = true
    }
    
    private func setConstraints(){
        contentView.fillSuperview()
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
}
