//
//  LoginView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class LoginView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "안녕하세요\n그대만의 은신처, 데드존입니다", lineHeight: 22)
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
    
    let passwordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "비밀번호")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var checkEmailAndPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일주소 혹은 비밀번호를 다시 확인해주세요."
        label.textAlignment = .left
        label.font = DZFont.subText12
        label.textColor = DZColor.errorColor
        label.isHidden = true
        return label
    }()

    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("데드존 입장하기", for: .normal)
        return button
    }()
    
    let resetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(DZColor.black, for: .normal)
        button.titleLabel?.font = DZFont.subText12
        return button
    }()
    
    private let seperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor100
        return view
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(DZColor.black, for: .normal)
        button.titleLabel?.font = DZFont.subText12
        return button
    }()
    
    private lazy var helperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [resetPasswordButton, seperatedView, registerButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 13
        return stackView
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
        addSubview(loginStackView)
        addSubview(checkEmailAndPasswordLabel)
        addSubview(doneButton)
        addSubview(helperStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(66)
            make.left.right.equalToSuperview().inset(16)
        }
        checkEmailAndPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(loginStackView.snp.bottom).offset(7)
            make.left.equalTo(loginStackView.snp.left).offset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(loginStackView.snp.bottom).offset(84)
            make.left.right.equalToSuperview().inset(16)
        }
        seperatedView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(12.5)
        }
        helperStackView.snp.makeConstraints { make in
            make.top.equalTo(doneButton.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
        }
    }
}
