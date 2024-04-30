//
//  HomeView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

final class HomeView: UIView {
    
    private let floorView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor300
        view.layer.borderColor = DZColor.grayColor200.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    var sofaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.sofa
        return imageView
    }()
    
    var cdplayerImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.cdplayer, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var wastedImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.wasted, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var meditationImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.meditation, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.table
        imageView.isHidden = true
        return imageView
    }()
    
    var iceCoffeeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.iceCoffee, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var fashion01ImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.fashion01, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var fashion02ImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.fashion02, for: .normal)
        button.isHidden = true
        return button
    }()
    
    var readingImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.reading, for: .normal)
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(floorView)
        addSubview(fashion01ImageButton)
        addSubview(sofaImageView)
        addSubview(cdplayerImageButton)
        addSubview(wastedImageButton)
        addSubview(meditationImageButton)
        addSubview(tableImageView)
        addSubview(fashion02ImageButton)
        addSubview(readingImageButton)
        addSubview(iceCoffeeImageButton)
        floorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        sofaImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(54)
            make.top.equalTo(floorView.snp.top).offset(-107.5)
        }
        cdplayerImageButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.bottom.equalTo(floorView.snp.top).offset(-175.5)
        }
        wastedImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(sofaImageView.snp.top).offset(-80)
            make.right.equalTo(sofaImageView.snp.right).inset(104)
        }
        meditationImageButton.snp.makeConstraints { make in
            make.top.equalTo(sofaImageView.snp.bottom).offset(119)
            make.left.equalToSuperview().offset(31)
        }
        tableImageView.snp.makeConstraints { make in
            make.top.equalTo(sofaImageView.snp.top).offset(126)
            make.right.equalTo(sofaImageView.snp.right).inset(76)
        }
        iceCoffeeImageButton.snp.makeConstraints { make in
            make.top.equalTo(tableImageView.snp.top).offset(-9)
            make.right.equalTo(tableImageView.snp.right).inset(15)
        }
        fashion01ImageButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(21)
            make.bottom.equalTo(sofaImageView.snp.bottom).offset(-52)
        }
        fashion02ImageButton.snp.makeConstraints { make in
            make.right.equalTo(sofaImageView.snp.left).offset(-21)
            make.bottom.equalTo(sofaImageView.snp.bottom).offset(3)
        }
        readingImageButton.snp.makeConstraints { make in
            make.left.equalTo(tableImageView.snp.left).offset(21)
            make.bottom.equalTo(tableImageView.snp.bottom).offset(-6)
        }
    }
}
