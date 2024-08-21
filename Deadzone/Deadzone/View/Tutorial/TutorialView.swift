//
//  TutorialView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class TutorialView: UIView {
    
    private let floorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let sofaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.sofa
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = DZColor.pointColor.withAlphaComponent(0.8).cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 1
        return imageView
    }()
    
    private let sofaTitleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("사진 기록을 남기고 싶다면\n각 활동에셋을 눌러요")
        label.numberOfLines = 2
        label.font = DZFont.subText12
        label.textColor = DZColor.backgroundColor
        label.textAlignment = .right
        return label
    }()
    
    lazy var sofaStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sofaTitleLabel, sofaImageView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .trailing
        stackView.isHidden = true
        return stackView
    }()
    
    private var assetButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.addasset, for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layer.shadowColor = DZColor.pointColor.withAlphaComponent(0.8).cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let assetTitleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("에셋을 추가하고\n싶다면 여기를 눌러요")
        label.numberOfLines = 2
        label.font = DZFont.subText12
        label.textColor = DZColor.backgroundColor
        label.textAlignment = .right
        return label
    }()
    
    lazy var assetStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [assetTitleLabel, assetButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .trailing
        stackView.isHidden = false
        return stackView
    }()
    
    private var archiveButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.archive, for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layer.shadowColor = DZColor.pointColor.withAlphaComponent(0.8).cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let archiveTitleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("아카이빙된 사진 기록이\n궁금하다면 여기를 눌러요")
        label.numberOfLines = 2
        label.font = DZFont.subText12
        label.textColor = DZColor.backgroundColor
        label.textAlignment = .right
        return label
    }()
    
    lazy var archiveStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [archiveTitleLabel, archiveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .trailing
        stackView.isHidden = true
        return stackView
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.uparrow
        imageView.isHidden = true
        return imageView
    }()
    
    let arrowTitleLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing("이웃 소식이 궁금하면\n화면을 위로 당겨주세요")
        label.numberOfLines = 2
        label.font = DZFont.subText12
        label.textColor = DZColor.backgroundColor
        label.textAlignment = .left
        label.isHidden = true
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
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(floorView)
        addSubview(sofaStackView)
        addSubview(assetStackView)
        addSubview(archiveStackView)
        addSubview(arrowImageView)
        addSubview(arrowTitleLabel)
        
        floorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        sofaStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(54)
            make.bottom.equalTo(floorView.snp.top).inset(32.5)
        }
        assetStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(78)
            make.bottom.equalToSuperview().inset(39)
        }
        archiveStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(39)
        }
        arrowImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(104)
        }
        arrowTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(94)
            make.bottom.equalToSuperview().inset(144)
        }
    }
}
