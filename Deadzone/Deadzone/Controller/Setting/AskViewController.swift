//
//  AskViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AskViewController: UIViewController {
    
    private let askView = AskView()
    
    private var history: String = "내역"
    private var askList: [AskAndAnswer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: history, style: .plain, target: self, action: #selector(historyButtonTapped))
        self.navigationItem.title = "1:1 문의"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(askView)
        askView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        askView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func historyButtonTapped(_ sender: UIButton) {
        let historyViewController = AskHistroyViewController()
        historyViewController.askList = askList
        self.navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        guard let askText = askView.writenTextView.text else { return }
        Networking.shared.postNewAsk(data: askText)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getData() {
        Networking.shared.getAsk { snapshot in
            self.history = self.history
            self.history += "(\(snapshot.count))"
            self.askList = snapshot
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.history, style: .plain, target: self, action: #selector(self.historyButtonTapped))
        }
    }
}
