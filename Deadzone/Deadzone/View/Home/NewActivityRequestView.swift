//
//  NewActivityRequestView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

final class NewActivityRequestView: UIView {
    
    private let placeholder: String = "추가하고 싶은 활동을 적어주세요."
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그대, 무엇을 추가하고 싶은가요?"
        label.font = DZFont.text16
        label.textColor = DZColor.black
        return label
    }()
    
    lazy var writenTextView: UITextView = {
        let textView = UITextView()
        textView.text = placeholder
        textView.setLineSpacing(textView.text)
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
        label.text = "300자 내로 적어주세요."
        label.font = DZFont.subText12
        label.textColor = DZColor.grayColor100
        return label
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("요청", for: .normal)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(writenTextView)
        addSubview(descriptionLabel)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        writenTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(75)
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

extension NewActivityRequestView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 300 {
            textView.deleteBackward()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
        }
    }
}

