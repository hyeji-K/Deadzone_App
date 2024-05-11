//
//  GallaryView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit

final class GallaryView: UIView {
    
    let recentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("최근", for: .normal)
        button.setTitleColor(DZColor.backgroundColor, for: .normal)
        button.titleLabel?.font = DZFont.text14
        return button
    }()
    
    let recentsUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.backgroundColor
        view.isHidden = false
        return view
    }()
    
    private lazy var recentsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recentsButton, recentsUnderlineView])
        stackView.axis = .vertical
        return stackView
    }()
    
//    let favoritesButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("즐겨찾는 항목", for: .normal)
//        button.setTitleColor(DZColor.subGrayColor100, for: .normal)
//        button.titleLabel?.font = DZFont.text14
//        return button
//    }()
//    
//    let favoritesUnderlineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = DZColor.subGrayColor100
//        view.isHidden = true
//        return view
//    }()
//    
//    private lazy var favoritesStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [favoritesButton, favoritesUnderlineView])
//        stackView.axis = .vertical
//        return stackView
//    }()
    
    let doneButton: UIButton = {
        var attString = AttributedString("완료")
        attString.font = DZFont.text14
        attString.foregroundColor = DZColor.backgroundColor
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attString
        configuration.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
        configuration.imagePadding = 6
        configuration.image = DZImage.check
        configuration.baseForegroundColor = DZColor.backgroundColor
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    
    private lazy var albumTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recentsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
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
        addSubview(albumTitleStackView)
        addSubview(doneButton)
        
        recentsUnderlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
//        favoritesUnderlineView.snp.makeConstraints { make in
//            make.height.equalTo(1)
//        }
        albumTitleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(23)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(23)
        }
    }
}
