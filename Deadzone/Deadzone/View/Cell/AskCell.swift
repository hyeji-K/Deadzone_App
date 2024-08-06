//
//  AskCell.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

final class AskCell: UITableViewCell {
    
    static let identifier: String = "AskCell"
    
    private let cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let askLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        label.textAlignment = .left
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
    
    func configure(ask: String) {
        askLabel.setLineSpacing(ask)
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(askLabel)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        askLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
