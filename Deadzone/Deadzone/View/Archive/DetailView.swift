//
//  DetailView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/21.
//

import UIKit

final class DetailView: UIView {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let captionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.caption
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 죽은 존씨:"
        label.textColor = DZColor.black
        label.font = DZFont.subTitle14
        return label
    }()
    
    let npcWordingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.npcWording
        imageView.isHidden = false
        return imageView
    }()
    
    lazy var writenTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = DZColor.black
        textView.font = DZFont.subTitle14
        textView.backgroundColor = .clear
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.delegate = self
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(photoImageView)
        addSubview(captionImageView)
        captionImageView.addSubview(titleLabel)
        captionImageView.addSubview(npcWordingImageView)
        captionImageView.addSubview(writenTextView)
        
        photoImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(154)
        }
        captionImageView.snp.makeConstraints { make in
//            make.top.equalTo(photoImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(5)
//            make.bottom.equalToSuperview().inset(34)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-34)
            make.height.equalTo(108)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(24)
        }
        npcWordingImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(19)
        }
        writenTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}

extension DetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        titleLabel.text = "그대:"
        npcWordingImageView.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            titleLabel.text = "이미 죽은 존씨:"
            npcWordingImageView.isHidden = false
        }
    }
}
