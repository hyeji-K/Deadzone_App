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
    
    lazy var newPasswordTextField: UITextField = {
        let textField = BasicTextField(placeholderText: "영문과 숫자 조합, 8자리 이상")
        textField.isSecureTextEntry = true
        textField.isSecureTextEntry = true
        textField.rightViewMode = .always
        textField.rightView = passwordEyeButton
        return textField
    }()
    
    let passwordEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.passDefault, for: .normal)
        return button
    }()
    
    let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "영문, 숫자 조합 8자리를 확인해주세요."
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
        addSubview(newPasswordTextField)
        addSubview(checkPasswordLabel)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.centerX.equalToSuperview()
        }
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(151)
            make.left.right.equalToSuperview().inset(16)
        }
        checkPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(4)
            make.left.equalTo(newPasswordTextField.snp.left).offset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(134)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
