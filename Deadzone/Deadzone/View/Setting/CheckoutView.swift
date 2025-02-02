//
//  CheckoutView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class CheckoutView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.setLineSpacing("처음 체크아웃을 하는 그대에게는 무료로\n활동 기록을 저장해드려요. 힘들면 언제든 찾아오세요!")
        label.setLineSpacing("힘들 때는 언제든 deadzone을 찾아오세요!")
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("체크아웃을 하면 활동기록은 저장되지 않습니다")
        label.textAlignment = .center
        label.font = DZFont.subText12
        label.textColor = DZColor.subGrayColor100
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.largeDoor
        return imageView
    }()
    
    let checkoutButton: UIButton = {
        let button = MainButton()
        button.setTitle("체크아웃", for: .normal)
        return button
    }()
    
    let accountCancellationButton: UIButton = {
        let button = UIButton()
        button.setTitle("아예 탈퇴하실 건가요?", for: .normal)
        button.setTitleColor(DZColor.subGrayColor100, for: .normal)
        button.titleLabel?.font = DZFont.subText10
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.subGrayColor100
        return view
    }()
    
    private lazy var accountCancellationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accountCancellationButton, underlineView])
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleStackView)
        addSubview(mainImageView)
        addSubview(checkoutButton)
        addSubview(accountCancellationStackView)
        
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(30)
        }
        checkoutButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(70)
            make.left.right.equalToSuperview().inset(16)
        }
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        accountCancellationStackView.snp.makeConstraints { make in
            make.top.equalTo(checkoutButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
    }
}
