//
//  SettingViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let settingView = SettingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "SETTING"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        settingView.tableView.separatorStyle = .none
        
        settingView.delegate = self
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingViewController: SettingDelegate {
    func showDetailView(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let userInfoSettingViewController = UserInfoSettingViewController()
            self.navigationController?.pushViewController(userInfoSettingViewController, animated: true)
        default:
            fatalError()
        }
    }
}
