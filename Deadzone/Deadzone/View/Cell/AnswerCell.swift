//
//  AnswerCell.swift
//  Deadzone
//
//  Created by heyji on 2024/07/09.
//

import UIKit

final class AnswerCell: UITableViewCell {
    
    static let identifier: String = "AnswerCell"
    
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
    
    private let answerView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor300
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText12
        label.textColor = DZColor.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = DZFont.subText10
        label.textColor = DZColor.grayColor100
        label.textAlignment = .right
        return label
    }()
    
    private lazy var answerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [answerLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
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
    
    func configure(ask: String, answer: String, date: String) {
        askLabel.text = "안녕하세요. 여쭤볼 것이 있습니다. 얼마 전에 새로운 활동을 요청했는데 혹시.. 언제쯤 업데이트가 되나요? 궁금해 미치겠어요."
        answerLabel.text = "안녕하세요, 이미죽은존씨입니다.\n\n그대가 요청하신 활동은 현재 검토 중으로 빠르면 2주 안에 업데이트가 될 예정입니다. 새로운 활동을 요청해주셔서 감사합니다. "
        dateLabel.text = "2024.03.12 답변"
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(askLabel)
        cellView.addSubview(answerView)
        answerView.addSubview(answerStackView)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        askLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        answerView.snp.makeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(16)
        }
        answerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
