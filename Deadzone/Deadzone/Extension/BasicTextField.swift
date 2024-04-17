//
//  BasicTextField.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class BasicTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        
        self.placeholder = placeholderText
        self.borderStyle = .line
        self.clipsToBounds = true
        self.layer.borderColor = DZColor.grayColor300.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.backgroundColor = DZColor.grayColor300
        self.addPadding(width: 16)
        self.textColor = DZColor.black
        self.font = DZFont.subText12
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        
        self.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
    }
}
