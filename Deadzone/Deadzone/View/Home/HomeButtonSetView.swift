//
//  HomeButtonSetView.swift
//  Deadzone
//
//  Created by heyji on 1/16/25.
//

import UIKit

final class HomeButtonSetView: UIView {
    
    var addAssetButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.addasset, for: .normal)
        return button
    }()
    
    var archiveButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.archive, for: .normal)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addAssetButton, archiveButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
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
        addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
