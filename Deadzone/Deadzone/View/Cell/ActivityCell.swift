//
//  ActivityCell.swift
//  Deadzone
//
//  Created by heyji on 2024/04/18.
//

import UIKit

final class ActivityCell: UICollectionViewCell {
    
    static let identifier: String = "ActivityCell"
    
    override var isSelected: Bool {
        didSet {
            self.cellView.backgroundColor = isSelected ? DZColor.pointColor : DZColor.backgroundColor
        }
    }
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.backgroundColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = DZColor.grayColor300.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private let activityImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 9
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, title: String) {
        activityImageView.image = image
        titleLabel.text = title
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(stackView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
    }
}
