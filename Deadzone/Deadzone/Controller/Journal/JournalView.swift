//
//  JournalView.swift
//  Deadzone
//
//  Created by heyji on 2024/08/10.
//

import UIKit

final class JournalView: UIView {
    
    // 스크롤뷰 추가
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // 컨텐츠뷰 추가
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.backgroundColor
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.layer.borderColor = DZColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = DZFont.subText12
        label.setLineSpacing("저쪽의\n'이미 죽은 존씨'가\n그대에게 보내신")
        label.textColor = DZColor.black
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = DZFont.text14
        label.text = "오늘의 짤"
        label.textColor = DZColor.black
        return label
    }()
    
    private let subImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DZColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let knockView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.pointColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let knockTitleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textAlignment = .center
        label.text = "같은 이유로 방문한 이웃에게 노크로 위로 전하기"
        label.textColor = DZColor.black
        return label
    }()
    
    private let knockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.journalIcon
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainImageUrl: String, subImageUrl: String) {
        self.mainImageView.setImageURL(mainImageUrl)
        self.subImageView.setImageURL(subImageUrl)
    }
    
    private func setupView() {
        backgroundColor = DZColor.backgroundColor
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(subView)
        contentView.addSubview(knockView)
        
        subView.addSubview(subTitleLabel)
        subView.addSubview(titleLabel)
        subView.addSubview(subImageView)
        knockView.addSubview(knockTitleLabel)
        knockView.addSubview(knockImageView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(945)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(573)
        }
        subView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(197)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(13)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().inset(15)
        }
        subImageView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(148)
        }
        knockView.snp.makeConstraints { make in
            make.top.equalTo(subView.snp.bottom).offset(37)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        knockTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        knockImageView.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(knockTitleLabel.snp.bottom).offset(2)
        }
    }
}
