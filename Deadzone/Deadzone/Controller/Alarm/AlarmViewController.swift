//
//  AlarmViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    private let alarmView = AlarmView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "ALARM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(alarmView)
        alarmView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        alarmView.tableView.separatorStyle = .none
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
