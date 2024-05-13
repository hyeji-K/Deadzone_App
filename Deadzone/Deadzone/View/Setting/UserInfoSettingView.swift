//
//  UserInfoSettingView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit

final class UserInfoSettingView: UIView {
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    lazy var nickNameTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "")
        textField.rightViewMode = .always
        textField.rightView = nickNameRemoveButton
        textField.rightView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }()
    
    lazy var nickNameRemoveButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.xmark, for: .normal)
        button.addTarget(self, action: #selector(nickNameClearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일주소"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "")
        textField.isEnabled = false
//        textField.keyboardType = .emailAddress
//        textField.rightViewMode = .always
//        textField.rightView = emailRemoveButton
//        textField.rightView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }()
    
//    let emailRemoveButton: UIButton = {
//        let button = UIButton()
//        button.setImage(DZImage.xmark, for: .normal)
//        return button
//    }()
    
    private let visitReasonLabel: UILabel = {
        let label = UILabel()
        label.text = "방문이유"
        label.textColor = DZColor.black
        label.font = DZFont.text14
        label.textAlignment = .left
        return label
    }()
    
    let visitReasonTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "")
        return textField
    }()
    
    let visitReasonButton: UIButton = {
        let button = UIButton()
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
        addSubview(nickNameLabel)
        addSubview(nickNameTextField)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(visitReasonLabel)
        addSubview(visitReasonTextField)
        visitReasonTextField.addSubview(visitReasonButton)
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(73)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(28)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        visitReasonLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(28)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
        visitReasonTextField.snp.makeConstraints { make in
            make.top.equalTo(visitReasonLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        visitReasonButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func nickNameClearButtonTapped(_ sender: UIButton) {
        nickNameTextField.text = ""
    }
}
