//
//  Extensions.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

extension UITextField {
    func addPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}

extension UILabel {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}

extension UITextView {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - 12) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
enum DZFontType {
    // Her-Leeoksun
    case mainTitle
    case subTitle
    
    // NanumSquareNeoOTF
    case heading
    case text16
    case text14
    case subText12
    case subText10
}

extension NSAttributedString {
    class func attributeFont(font: DZFontType, text: String, lineHeight: CGFloat) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        if #available(iOS 14.0, *) {
            paragraphStyle.lineBreakStrategy = .hangulWordPriority
        } else {
            paragraphStyle.lineBreakStrategy = .pushOut
        }
        
        var setFont = UIFont()
        switch font {
        case .mainTitle:
            setFont = UIFont(name: "Her-Leeoksun", size: 40)!
        case .subTitle:
            setFont = UIFont(name: "Her-Leeoksun", size: 22)!
        case .heading:
            setFont = UIFont(name: "NanumSquareNeo-cBd", size: 18)!
        case .text16:
            setFont = UIFont(name: "NanumSquareNeo-bRg", size: 16)!
        case .text14:
            setFont = UIFont(name: "NanumSquareNeo-bRg", size: 14)!
        case .subText12:
            setFont = UIFont(name: "NanumSquareNeo-bRg", size: 12)!
        case .subText10:
            setFont = UIFont(name: "NanumSquareNeo-bRg", size: 10)!
        }
        
        paragraphStyle.lineSpacing = lineHeight - setFont.lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        attrString.addAttributes([
                    NSAttributedString.Key.paragraphStyle : paragraphStyle,
                    .font : setFont
                ], range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
}
