//
//  AccountCancellationView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AccountCancellationView: UIView {
    
    let placeholder: String = "떠나시는 이유가 궁금합니다..."
    
    lazy var writenTextView: UITextView = {
        let textView = UITextView()
        textView.text = placeholder
        textView.setLineSpacing(textView.text)
        textView.textColor = DZColor.grayColor100
        textView.font = DZFont.subText12
        textView.backgroundColor = DZColor.grayColor300
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 24, left: 14, bottom: 16, right: 14)
        textView.returnKeyType = .done
        textView.delegate = self
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자유롭게 적어주세요."
        label.font = DZFont.subText12
        label.textColor = DZColor.grayColor100
        return label
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("탈퇴", for: .normal)
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
        addSubview(writenTextView)
        addSubview(descriptionLabel)
        addSubview(doneButton)
        writenTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98)
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

extension AccountCancellationView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
