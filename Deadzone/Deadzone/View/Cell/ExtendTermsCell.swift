//
//  ExtendTermsCell.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

final class ExtendTermsCell: UITableViewCell {
    
    static let identifier: String = "ExtendTermsCell"
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textColor = .black
        label.numberOfLines = 0
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
    
    func configure(title: String) {
        titleLabel.setLineSpacing(title)
    }
    
    private func setupCell() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleLabel)
        
        cellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(17)
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
