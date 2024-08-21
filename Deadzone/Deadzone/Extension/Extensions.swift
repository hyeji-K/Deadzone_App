//
//  Extensions.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

extension UITextField {
    func isCorrecting(value: Bool) {
        if value {
            self.layer.borderColor = DZColor.grayColor300.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = DZColor.grayColor300            
        } else {
            self.layer.borderColor = DZColor.red02.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = DZColor.red02
        }
    }
    
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
    
    func setLineSpacing(_ text: String?) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UITextView {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
//        let fontSize: CGFloat = 14
//        let lineheight = fontSize * 1.6  //font size * multiple
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - 14) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    func setLineSpacing(_ text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: self.text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
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

extension String {
    // 이메일 유효성 검사
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    // 비밀번호 유효성 검사
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + " ..."
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension Date {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var stringFormat: String {
        return Date.dateFormatter.string(from: self)
    }
    
    static var askDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    var askDateStringFormat: String {
        return Date.askDateFormatter.string(from: self)
    }
}

extension Int {
    var boolValue: Bool {
        return self != 1
    }
}

//extension UINavigationController {
//    func popViewController(animated: Bool, completion:@escaping (()->())) -> UIViewController? {
//        CATransaction.setCompletionBlock(completion)
//        CATransaction.begin()
//        let poppedViewController = self.popViewController(animated: animated)
//        CATransaction.commit()
//        return poppedViewController
//    }
//    
//    func pushViewController(_ viewController: UIViewController, animated: Bool, completion:@escaping (()->())) {
//        CATransaction.setCompletionBlock(completion)
//        CATransaction.begin()
//        self.pushViewController(viewController, animated: animated)
//        CATransaction.commit()
//    }
//}
