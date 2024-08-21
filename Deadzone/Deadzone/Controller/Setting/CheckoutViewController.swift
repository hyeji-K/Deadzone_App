//
//  CheckoutViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    private let checkoutView = CheckoutView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "체크아웃"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(checkoutView)
        checkoutView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.checkoutView.checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        self.checkoutView.accountCancellationButton.addTarget(self, action: #selector(accountCancellationButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkoutButtonTapped(_ sender: UIButton) {
        // 로그아웃하며 로그인 화면으로 화면전환
        Networking.shared.signOut()
        Networking.shared.getUserInfo { user in
            let archive = user.archive
            if archive.first != "" {
                var removeArchive: [String] = []
                for i in archive {
                    removeArchive.append(self.changeCatagotyName(name: i))
                }
                if removeArchive.count == 1 {
                    Networking.shared.deleteArchiveData(firstArchiveName: removeArchive.first!)
                } else if removeArchive.count == 2 {
                    Networking.shared.deleteArchiveData(firstArchiveName: removeArchive.first!, secondArchiveName: removeArchive.last!)
                }                
            }
        }
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: false)
    }
    
    @objc private func accountCancellationButtonTapped(_ sender: UIButton) {
        // 탈퇴 화면으로 전환
        let accountCancellationVC = AccountCancellationViewController()
        self.navigationController?.pushViewController(accountCancellationVC, animated: true)
    }
    
    func changeCatagotyName(name: String) -> String {
        switch name {
        case "음악":
            return "music"
        case "카페":
            return "cafe"
        case "명상":
            return "meditation"
        case "독서":
            return "reading"
        case "음주":
            return "drinking"
        case "패션":
            return "fashion01"
        default:
            return ""
        }
    }
}
