//
//  AlertSettingViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AlertSettingViewController: UIViewController {
    
    private let alertSettingView = AlertSettingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(alertSettingView)
        alertSettingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
