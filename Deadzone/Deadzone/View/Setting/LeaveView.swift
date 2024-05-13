//
//  LeaveView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class LeaveView: UIView {
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.mediumDoor
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("탈퇴 신청일로부터 7일 뒤 계정 정보가 모두 삭제됩니다.\n계정 정보는 관련 법령 및 개인정보처리방침에 따라 파기 및 보관이 이루어집니다.")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그대, 즐거웠다."
        label.textAlignment = .center
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(171)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(33)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(146)
            make.centerX.equalToSuperview()
        }
    }
}
