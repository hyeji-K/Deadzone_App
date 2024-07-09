//
//  AskHistoryView.swift
//  Deadzone
//
//  Created by heyji on 2024/07/07.
//

import UIKit

struct cellData {
    var opened = Bool()
//    var title = String()
//    var sectionData = [String]()
}

final class AskHistoryView: UIView {
    
    lazy var askTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if opened == false {
//            return 2
//        } else {
            return 2
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // NOTE: 사용자의 질문
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
            cell.configure(title: "", date: "")
            return cell
        } else {
            // NOTE: 운영자의 답변
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as! AnswerCell
            cell.configure(ask: "", answer: "", date: "")
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
//        dataDelegate?.sendData(data: feelingList[indexPath.row])
        if indexPath.row == 0 {
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            
        }
    }
}
