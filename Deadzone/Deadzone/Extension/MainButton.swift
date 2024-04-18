//
//  MainButton.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class MainButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = DZColor.black
                self.setTitleColor(DZColor.backgroundColor, for: .normal)
            } else {
                self.backgroundColor = DZColor.grayColor200
                self.setTitleColor(DZColor.black, for: .normal)
            }
        }
    }
    
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
        
        self.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
}
