//
//  TermsOfUseView.swift
//  Deadzone
//
//  Created by heyji on 2024/07/10.
//

import UIKit

final class TermsOfUseView: UIView {
    
    private let mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.profile
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        let attributedString = NSMutableAttributedString(string: "그대,\n데드존에 온 것을 환영해.")
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        label.numberOfLines = 2
        label.textAlignment = .right
        label.font = DZFont.text16
        label.textColor = .black
        return label
    }()
    
    private lazy var imageAndTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .trailing
        return stackView
    }()
    
    let agreeToAllTermsButton: UIButton = {
        var attString = AttributedString("약관 전체동의")
        attString.font = DZFont.text14
        attString.foregroundColor = DZColor.black
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attString
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 13)
        configuration.imagePadding = 14
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.setImage(DZImage.termsCheckOff, for: .normal)
        button.setImage(DZImage.termsCheckOn, for: .selected)
        button.tintColor = DZColor.black
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainView, agreeToAllTermsButton])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let seperaterlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor200
        return view
    }()
    
    let agreeToTermsButton: UIButton = {
        var attString = AttributedString("이용약관 동의(필수)")
        attString.font = DZFont.text14
        attString.foregroundColor = DZColor.black
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attString
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 13)
        configuration.imagePadding = 14
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.setImage(DZImage.termsCheckOff, for: .normal)
        button.setImage(DZImage.termsCheckOn, for: .selected)
        button.tintColor = DZColor.black
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    let detailsOfAgreeToTermsView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let detailsOfAgreeToTermsButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.vector, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var agreeToTermsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreeToTermsButton, detailsOfAgreeToTermsView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    let agreeToPrivacyButton: UIButton = {
        var attString = AttributedString("개인정보 수집 및 이용 동의(필수)")
        attString.font = DZFont.text14
        attString.foregroundColor = DZColor.black
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attString
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 13)
        configuration.imagePadding = 14
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.setImage(DZImage.termsCheckOff, for: .normal)
        button.setImage(DZImage.termsCheckOn, for: .selected)
        button.tintColor = DZColor.black
        
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    let detailsOfAgreeToPrivacyView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let detailsOfAgreeToPrivacyButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.vector, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreeToPrivacyButton, detailsOfAgreeToPrivacyView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("확인", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainStackView)
        mainView.addSubview(imageAndTitleStackView)
        addSubview(seperaterlineView)
        detailsOfAgreeToTermsView.addSubview(detailsOfAgreeToTermsButton)
        detailsOfAgreeToPrivacyView.addSubview(detailsOfAgreeToPrivacyButton)
        addSubview(agreeToTermsStackView)
        addSubview(StackView)
        addSubview(doneButton)
        
        imageAndTitleStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        agreeToAllTermsButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        detailsOfAgreeToTermsButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        detailsOfAgreeToPrivacyButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
        }
        seperaterlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(mainStackView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        agreeToTermsStackView.snp.makeConstraints { make in
            make.top.equalTo(seperaterlineView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(32)
            make.right.equalToSuperview().inset(26)
            make.height.equalTo(32)
        }
        StackView.snp.makeConstraints { make in
            make.top.equalTo(agreeToTermsStackView.snp.bottom).offset(26)
            make.left.equalToSuperview().inset(32)
            make.right.equalToSuperview().inset(26)
            make.height.equalTo(32)
            make.bottom.equalTo(doneButton.snp.top).inset(-43)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
