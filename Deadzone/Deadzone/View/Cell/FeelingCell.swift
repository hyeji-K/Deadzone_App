//
//  FeelingCell.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

final class FeelingCell: UITableViewCell {
    
    static let identifier: String = "FeelingCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor300
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.text14
        label.textColor = DZColor.grayColor100
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        willSet {
            self.setSelected(newValue, animated: true)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.mainView.backgroundColor = DZColor.pointColor
            self.titleLabel.textColor = DZColor.black
        }  else {
            self.mainView.backgroundColor = DZColor.grayColor300
            self.titleLabel.textColor = DZColor.grayColor100
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupCell() {
        contentView.addSubview(mainView)
        mainView.addSubview(titleLabel)
        
        mainView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.left.right.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
