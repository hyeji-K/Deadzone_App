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
    
    var cdplayerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.cdplayer
        imageView.isHidden = true
        return imageView
    }()
    
    var wastedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.wasted
        imageView.isHidden = true
        return imageView
    }()
    
    var meditationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.meditation
        imageView.isHidden = true
        return imageView
    }()
    
    var tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.table
        imageView.isHidden = true
        return imageView
    }()
    
    var iceCoffeeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.iceCoffee
        imageView.isHidden = true
        return imageView
    }()
    
    var fashion01ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.fashion01
        imageView.isHidden = true
        return imageView
    }()
    
    var fashion02ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.fashion02
        imageView.isHidden = true
        return imageView
    }()
    
    var readingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.reading
        imageView.isHidden = true
        return imageView
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
        addSubview(fashion01ImageView)
        addSubview(sofaImageView)
        addSubview(cdplayerImageView)
        addSubview(wastedImageView)
        addSubview(meditationImageView)
        addSubview(tableImageView)
        addSubview(iceCoffeeImageView)
        addSubview(fashion02ImageView)
        addSubview(readingImageView)
        floorView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        sofaImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(54)
            make.top.equalTo(floorView.snp.top).offset(-107.5)
        }
        cdplayerImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.bottom.equalTo(floorView.snp.top).offset(-175.5)
        }
        wastedImageView.snp.makeConstraints { make in
            make.bottom.equalTo(sofaImageView.snp.top).offset(-80)
            make.right.equalTo(sofaImageView.snp.right).inset(104)
        }
        meditationImageView.snp.makeConstraints { make in
            make.top.equalTo(sofaImageView.snp.bottom).offset(119)
            make.left.equalToSuperview().offset(31)
        }
        tableImageView.snp.makeConstraints { make in
            make.top.equalTo(sofaImageView.snp.top).offset(126)
            make.right.equalTo(sofaImageView.snp.right).inset(76)
        }
        iceCoffeeImageView.snp.makeConstraints { make in
            make.top.equalTo(tableImageView.snp.top).offset(-9)
            make.right.equalTo(tableImageView.snp.right).inset(15)
        }
        fashion01ImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(21)
            make.bottom.equalTo(sofaImageView.snp.bottom).offset(-52)
        }
        fashion02ImageView.snp.makeConstraints { make in
            make.right.equalTo(sofaImageView.snp.left).offset(-21)
            make.bottom.equalTo(sofaImageView.snp.bottom).offset(3)
        }
        readingImageView.snp.makeConstraints { make in
            make.left.equalTo(tableImageView.snp.left).offset(21)
            make.bottom.equalTo(tableImageView.snp.bottom).offset(-6)
        }
    }
}
