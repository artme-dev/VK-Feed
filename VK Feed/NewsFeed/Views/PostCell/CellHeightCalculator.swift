//
//  CellHeightCalculator.swift
//  VK Feed
//
//  Created by Артём on 17.08.2021.
//

import UIKit

typealias CellHeights = (revealedCellHeight: CGFloat, concealedCellHeight: CGFloat?)

final class CellHeightCalculator{
    private init(){}
    
    private static func textLabelHeight(_ text: String?) -> CGFloat{
        guard let text = text else { return 0 }
        let contentFont = PostContentView.Constants.textFont
        let screenWidth = UIScreen.main.bounds.width
        let contentPaddingsWidth = FeedTableViewCell.Constants.textPaddingsWidth
        let contentHeight = text.boundingRectHeight(width: screenWidth - contentPaddingsWidth, font: contentFont)
        
        return contentHeight
    }
    
    private static func isConcealingText(height: CGFloat) -> Bool{
        let concealingTextMinLinesCount = PostContentView.Constants.concealingTextMinLinesCount
        let textFont = PostContentView.Constants.textFont
        let concealingTextMinHeight = CGFloat(concealingTextMinLinesCount) * textFont.lineHeight
        let isConcealingText = (height >= concealingTextMinHeight)
        return isConcealingText
    }
    
    private static func fixCellPartHeight() -> CGFloat{
        let infoViewHeight = FeedTableViewCell.Constants.infoViewHeight
        let actionsViewHeight = FeedTableViewCell.Constants.actionViewHeight
        let cellPaddingsHeight = FeedTableViewCell.Constants.postPaddingsHeight
        let fixCellPartHeight = infoViewHeight + actionsViewHeight + cellPaddingsHeight
        return fixCellPartHeight
    }
    
    private static func revealedTextHeight(text: String) -> CGFloat{
        let textHeight = textLabelHeight(text)
        let revealedTextHeight = textHeight + FeedTableViewCell.Constants.textPaddingsHeight
        return revealedTextHeight
    }
    
    private static func concealedTextHeight() -> CGFloat{
        let concealedTextLinesCount = PostContentView.Constants.concealedTextLinesCount
        let lineHeight = PostContentView.Constants.textFont.lineHeight
        return lineHeight * CGFloat(concealedTextLinesCount) + PostContentView.Constants.buttonHeight
    }
    
    static func cellHeights(text: String?) -> CellHeights{
        guard let text = text else { return (0, nil) }
        
        let revealedTextHeight = revealedTextHeight(text: text)
        let isConcealingText = isConcealingText(height: revealedTextHeight)
        
        let revealedCellHeight = fixCellPartHeight() + revealedTextHeight
        let concealedCellHeight = isConcealingText ? fixCellPartHeight() + concealedTextHeight() : nil
        
        return (revealedCellHeight, concealedCellHeight)
    }
}
