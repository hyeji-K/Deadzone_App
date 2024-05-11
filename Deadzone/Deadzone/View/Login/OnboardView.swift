//
//  OnboardView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class OnboardView: UIView {

    private let pageControlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.pageControl1
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "데드존에서 사용하실\n닉네임은 무엇인가요?", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "5자리 내 한글, 영문, 숫자 조합"
        textField.borderStyle = .line
        textField.clipsToBounds = true
        textField.layer.borderColor = DZColor.grayColor300.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.backgroundColor = DZColor.grayColor300
        textField.addPadding(width: 16)
        textField.textColor = DZColor.grayColor100
        textField.font = DZFont.text14
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.nextButton, for: .normal)
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
        addSubview(pageControlImageView)
        addSubview(titleLabel)
        addSubview(nicknameTextField)
        addSubview(nextButton)
        
        pageControlImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControlImageView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
