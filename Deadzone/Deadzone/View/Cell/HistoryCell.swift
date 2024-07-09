//
//  HistoryCell.swift
//  Deadzone
//
//  Created by heyji on 2024/07/07.
//

import UIKit

final class HistoryCell: UITableViewCell {
    
    static let identifier: String = "HistoryCell"
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.text14
        label.textColor = DZColor.black
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText10
        label.textColor = DZColor.grayColor100
        label.textAlignment = .left
        return label
    }()
    
    let extendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        return button
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String, date: String) {
        titleLabel.text = "안녕하세요. 여쭤볼 것이 있습니다."
        dateLabel.text = "2024. 03. 11 작성"
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(extendButton)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.left.equalToSuperview().offset(13)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
        }
        extendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(13)
        }
    }
}
