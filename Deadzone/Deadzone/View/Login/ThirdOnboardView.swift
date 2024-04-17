//
//  ThirdOnboardView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class ThirdOnboardView: UIView {
    
    private let placeholder: String = "오로지 자신의 감정을 되돌아보기 위한 목적이며\n절대 타인에게 공유되지 않습니다:)"

    private let pageControlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.pageControl3
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "그러셨군요.\n그렇게 느낀 이유를 설명해주시겠어요?", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    private lazy var writenTextView: UITextView = {
        let textView = UITextView()
        textView.attributedText = NSAttributedString.attributeFont(font: .subText12, text: placeholder, lineHeight: 16)
        textView.textColor = DZColor.grayColor100
        textView.font = DZFont.subText12
        textView.backgroundColor = DZColor.grayColor300
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 24, left: 14, bottom: 16, right: 14)
        textView.delegate = self
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "분량 상관없이 천천히, 자유롭게 적어주세요."
        label.font = DZFont.subText12
        label.textColor = DZColor.subGrayColor100
        return label
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("데드존 입장하기", for: .normal)
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
        addSubview(writenTextView)
        addSubview(descriptionLabel)
        addSubview(doneButton)
        
        pageControlImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControlImageView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        writenTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(294)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(writenTextView.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}

extension ThirdOnboardView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
}
