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
    
    func configure(answer: String, date: String) {
        let transAnswer = answer.replacingOccurrences(of: "\\\\n", with: "\n")
        answerLabel.setLineSpacing(transAnswer)
        guard let date = date.date else { return }
        dateLabel.text = "\(date.askDateStringFormat) 답변"
    }
    
    private func setupCell() {
        addSubview(cellView)
        cellView.addSubview(answerView)
        answerView.addSubview(answerStackView)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        answerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(28)
        }
        answerStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
