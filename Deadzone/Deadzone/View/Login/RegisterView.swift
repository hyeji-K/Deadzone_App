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
    
    let emailTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "loppyhouse@gmail.com")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let emailErrorCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 형식이 잘못되었어요."
        label.textAlignment = .left
        label.font = DZFont.subText10
        label.textColor = DZColor.errorColor
        label.isHidden = true
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "영문과 숫자 조합, 8자리 이상")
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.rightViewMode = .always
        textField.rightView = passwordEyeButton
        return textField
    }()
    
    let passwordEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.passDefault, for: .normal)
        return button
    }()
    
    let passwordErrorCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "영문, 숫자 조합 8자리를 확인해주세요."
        label.textAlignment = .left
        label.font = DZFont.subText10
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
        addSubview(emailErrorCheckLabel)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(passwordErrorCheckLabel)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        emailErrorCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.left.equalTo(emailTextField.snp.left).offset(8)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(47)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordErrorCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.left.equalTo(passwordTextField.snp.left).offset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(121)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
