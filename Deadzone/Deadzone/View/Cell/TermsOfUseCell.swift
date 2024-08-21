//
//  TermsOfUseCell.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

final class TermsOfUseCell: UITableViewCell {
    
    static let identifier: String = "TermsOfUseCell"
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.text14
        label.textColor = .black
        return label
    }()
    
    let accessoryButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.vector, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let seperaterlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor200
        return view
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
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupCell() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(accessoryButton)
        cellView.addSubview(seperaterlineView)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        accessoryButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(32)
        }
        seperaterlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
