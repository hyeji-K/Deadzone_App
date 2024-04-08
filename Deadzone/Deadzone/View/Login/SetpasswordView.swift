//
//  SetpasswordView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class SetpasswordView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: "비밀번호를 재설정해주세요.", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "영문과 숫자를 조합해 8자리 이상이어야 합니다."
        label.textColor = DZColor.black02
        label.font = DZFont.text14
        label.textAlignment = .center
        return label
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "새로운 비밀번호")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let checkPasswordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "비밀번호 확인")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newPasswordTextField, checkPasswordTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 다시 한번 확인해주세요."
        label.textAlignment = .left
        label.font = DZFont.subText12
        label.textColor = DZColor.errorColor
        label.isHidden = true
        return label
    }()

    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("비밀번호 변경 완료", for: .normal)
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
        addSubview(subTitleLabel)
        addSubview(passwordStackView)
        addSubview(checkPasswordLabel)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(85)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        passwordStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(59)
            make.left.right.equalToSuperview().inset(16)
        }
        checkPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(7)
            make.left.equalTo(passwordStackView.snp.left).offset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(84)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
