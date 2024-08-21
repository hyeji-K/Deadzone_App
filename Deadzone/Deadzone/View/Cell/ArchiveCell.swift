//
//  ArchiveCell.swift
//  Deadzone
//
//  Created by heyji on 2024/04/20.
//

import UIKit

final class ArchiveCell: UICollectionViewCell {
    
    static let identifier: String = "ArchiveCell"
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = DZColor.backgroundColor
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = DZImage.defaultCheck
        return imageView
    }()
    
    private let borderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.border
        return imageView
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
    
    func configure(archive: Archive) {
//        guard let url = URL(string: archive.imageUrl) else { return }
//        if let data = try? Data(contentsOf: url) {
//            if let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.photoImageView.image = image
//                }
//            }
//        }
        photoImageView.setImageURL(archive.imageUrl)
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(photoImageView)
        cellView.addSubview(borderImageView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        photoImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(2)
            make.top.equalToSuperview().inset(3)
        }
        borderImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
