//
//  GallaryCell.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit

final class GallaryCell: UICollectionViewCell {
    
    static let identifier: String = "GallaryCell"
    var representedAssetIdentifier: String?
    
    override var isSelected: Bool {
        didSet {
            self.checkButton.setImage(isSelected ? DZImage.activeCheck : DZImage.defaultCheck, for: .normal)
        }
    }
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.defaultCheck, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    func configure(image: UIImage) {
        photoImageView.image = image
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(photoImageView)
        photoImageView.addSubview(checkButton)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(4)
            make.width.height.equalTo(22)
        }
    }
}
