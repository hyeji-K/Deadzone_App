//
//  MainButton.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class MainButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.titleLabel?.font = DZFont.text16
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        
        switch self.isEnabled {
        case true:
            self.backgroundColor = DZColor.black
            self.setTitleColor(DZColor.backgroundColor, for: .normal)
        case false:
            self.backgroundColor = DZColor.subGrayColor193
            self.setTitleColor(DZColor.black03, for: .normal)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}
