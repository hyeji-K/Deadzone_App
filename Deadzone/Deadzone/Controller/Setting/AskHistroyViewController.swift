//
//  AskHistroyViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/07/07.
//

import UIKit

final class AskHistroyViewController: UIViewController {
    
    private let historyView = AskHistoryView()
    
    var askList: [AskAndAnswer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        getData()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "1:1 문의 내역"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(16)
        }
        
        historyView.askTableView.separatorStyle = .none
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getData() {
        var transAskList: [CellData] = []
        for ask in askList {
            let askData = CellData(ask: Ask(ask: ask.ask, date: ask.askCreatedAt), answer: Answer(answer: ask.answer, date: ask.answerCreatedAt))
            transAskList.append(askData)
        }
        historyView.tableViewData = transAskList
    }
}
