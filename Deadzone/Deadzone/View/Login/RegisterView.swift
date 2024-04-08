//
//  RegisterView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class RegisterView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: "회원가입", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일주소"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "loppyhouse@gmail.com")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "영문과 숫자 조합, 8자리 이상")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    private let checkPasswordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let errorCheckPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "다시 한번 확인해주세요."
        label.textAlignment = .left
        label.font = DZFont.subText12
        label.textColor = DZColor.errorColor
        label.isHidden = true
        return label
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("입력 완료", for: .normal)
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
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(checkPasswordLabel)
        addSubview(checkPasswordTextField)
        addSubview(errorCheckPasswordLabel)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(85)
            make.centerX.equalToSuperview()
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(63)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(38)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(7)
            make.left.right.equalToSuperview().inset(16)
        }
        checkPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordLabel.snp.bottom).offset(7)
            make.left.right.equalToSuperview().inset(16)
        }
        errorCheckPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(8)
            make.left.equalTo(checkPasswordTextField.snp.left).offset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(121)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
