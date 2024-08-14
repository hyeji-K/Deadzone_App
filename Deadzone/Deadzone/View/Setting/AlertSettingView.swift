//
//  AlertSettingView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AlertSettingView: UIView {
    
    private let knockingLabel: UILabel = {
        let label = UILabel()
        label.text = "노크 허용 여부"
        label.font = DZFont.text14
        label.textColor = DZColor.black
        return label
    }()
    
    var knockingButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.off, for: .normal)
        return button
    }()
    
    private lazy var knockingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [knockingLabel, knockingButton])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let knockingDescriptionLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("데드존에서는 노크로 이웃간에 위로를 주고받아요.\n부담이 될 땐 노크를 닫고, 응원이 필요할 땐 허용해보세요.")
        label.numberOfLines = 2
        label.font = DZFont.subText10
        label.textColor = DZColor.subGrayColor100
        return label
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 허용 여부"
        label.font = DZFont.text14
        label.textColor = DZColor.black
        return label
    }()
    
    var alertButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.on, for: .normal)
        return button
    }()
    
    private lazy var alertStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [alertLabel, alertButton])
        stackView.axis = .horizontal
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
        addSubview(knockingStackView)
        addSubview(knockingDescriptionLabel)
        addSubview(alertStackView)
        
        knockingStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(32)
        }
        knockingDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(knockingStackView.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(18)
        }
        alertStackView.snp.makeConstraints { make in
            make.top.equalTo(knockingDescriptionLabel.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(32)
        }
        
        UNUserNotificationCenter.current().requestAuthorization { didAllow, error in
            if didAllow {
                DispatchQueue.main.async {
                    self.alertButton.setImage(DZImage.on, for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.alertButton.setImage(DZImage.off, for: .normal)
                }
            }
        }
    }
}
