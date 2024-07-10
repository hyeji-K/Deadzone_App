//
//  RepasswordViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit

final class RepasswordViewController: UIViewController {
    
    private let repasswordView = RepasswordView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(repasswordView)
        repasswordView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        repasswordView.resettingButton.addTarget(self, action: #selector(resettingButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func resettingButtonTapped(_ sender: UIButton) {
        // 이메일로 존재하는 사용자인지 확인 후 화면 전환
//        print(Auth.auth().currentUser?.email) // 이전에 로그인한 이메일이 저장되어 있음
        Networking.shared.getUserEmail { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                let email = snapshot["email"] as? String
                if self.repasswordView.emailTextField.text == email {
                    self.repasswordView.emailTextField.isCorrecting(value: true)
                    self.repasswordView.checkEmailLabel.isHidden = true
                    let setpasswordViewController = SetpasswordViewController()
                    self.navigationController?.pushViewController(setpasswordViewController, animated: false)
                } else {
                    self.repasswordView.emailTextField.isCorrecting(value: false)
                    self.repasswordView.checkEmailLabel.isHidden = false
                }
            }
        }
    }
}
