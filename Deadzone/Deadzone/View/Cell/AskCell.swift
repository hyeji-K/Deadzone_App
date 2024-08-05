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
        askLabel.setLineSpacing("안녕하세요. 여쭤볼 것이 있습니다. 얼마 전에 새로운 활동을 요청했는데 혹시.. 언제쯤 업데이트가 되나요? 궁금해 미치겠어요.")
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
