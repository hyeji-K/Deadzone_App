//
//  AskHistoryView.swift
//  Deadzone
//
//  Created by heyji on 2024/07/07.
//

import UIKit

struct cellData {
    var opened = Bool()
    var ask = String()
    var answer = [Answer]()
}

final class AskHistoryView: UIView {
    
    private var tableViewData = [cellData(opened: false, ask: "일", answer: [Answer(answer: "", date: "")]),
                                 cellData(opened: false, ask: "이", answer: [])]
    
    lazy var askTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableView.register(AskCell.self, forCellReuseIdentifier: AskCell.identifier)
        tableView.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.identifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(askTableView)
        
        askTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AskHistoryView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            if tableViewData[section].answer.isEmpty {
                return 2
            }
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // NOTE: 히스토리
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
            cell.configure(title: "", date: "")
            return cell
        } else if indexPath.row == 1 {
            // NOTE: 사용자의 질문
            let cell = tableView.dequeueReusableCell(withIdentifier: AskCell.identifier, for: indexPath) as! AskCell
            cell.configure(ask: "")
            return cell
        } else {
            // NOTE: 운영자의 답변
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as! AnswerCell
            cell.configure(answer: "", date: "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 77
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        if !tableViewData[indexPath.section].opened {
            cell.extendButton.setImage(DZImage.answerVector, for: .normal)
        } else {
            cell.extendButton.setImage(DZImage.askVector, for: .normal)
        }
        if indexPath.row == 0 {
            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
//            tableView.reloadData()
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}
