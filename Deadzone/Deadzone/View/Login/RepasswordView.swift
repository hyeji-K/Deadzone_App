//
//  RepasswordView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class RepasswordView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "데드존에 가입되어 있는\n이메일주소를 입력해주세요.", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "이메일주소")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let checkEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 형식이 잘못되었어요."
        label.textAlignment = .left
        label.font = DZFont.subText12
        label.textColor = DZColor.errorColor
        label.isHidden = true
        return label
    }()
    
    let resettingButton: UIButton = {
        let button = MainButton()
        button.setTitle("비밀번호 재설정", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(checkEmailLabel)
        addSubview(resettingButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(83)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(196)
            make.left.right.equalToSuperview().inset(16)
        }
        checkEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.left.equalTo(emailTextField.snp.left).offset(8)
        }
        resettingButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(134)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
