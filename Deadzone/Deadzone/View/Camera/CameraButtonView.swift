//
//  CameraButtonView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit

final class CameraButtonView: UIView {
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "button.programmable"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 65), forImageIn: .normal)
        return button
    }()
    
    let albumButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 26), forImageIn: .normal)
        return button
    }()
    
    let reversalButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 26), forImageIn: .normal)
        return button
    }()
    
    var zoomSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1.0
        slider.minimumValueImage = UIImage(systemName: "minus")
        slider.maximumValueImage = UIImage(systemName: "plus")
        slider.tintColor = DZColor.backgroundColor
        slider.maximumValue = 4.0
        slider.minimumValue = 1.0
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .black
        addSubview(cameraButton)
        addSubview(albumButton)
        addSubview(reversalButton)
        addSubview(zoomSlider)
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        albumButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(cameraButton.snp.centerY)
        }
        reversalButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(cameraButton.snp.centerY)
        }
        zoomSlider.snp.makeConstraints { make in
            make.bottom.equalTo(cameraButton.snp.top).inset(-30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
    }
}
