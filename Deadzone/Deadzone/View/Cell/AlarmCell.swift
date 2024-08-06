//
//  AlarmCell.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

enum AlarmImage {
    case journal
    case announcement
    case knock
    
    var message: String {
        switch self {
        case .journal:
            return "새로운 격일간지가 도착했어요."
        case .announcement:
            return "요청하신 활동이 추가되었어요."
        case .knock:
            return "앵O님이 문을 두드렸어요."
        }
    }
}

final class AlarmCell: UITableViewCell {
    
    static let identifier: String = "AlarmCell"
    
    private let mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let alarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.journal
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, title: String) {
        alarmImageView.image = image
        titleLabel.text = AlarmImage.journal.message
    }
    
    private func setupCell() {
        contentView.addSubview(mainView)
        mainView.addSubview(alarmImageView)
        mainView.addSubview(titleLabel)
        
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.top.equalToSuperview()
        }
        alarmImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview()
        }
    }
}
