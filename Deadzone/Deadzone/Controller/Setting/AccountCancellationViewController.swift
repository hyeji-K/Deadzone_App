//
//  AccountCancellationViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AccountCancellationViewController: UIViewController {
    
    private let accountCancellationView = AccountCancellationView()
    private let leaveView = LeaveView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "탈퇴"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(accountCancellationView)
        accountCancellationView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        accountCancellationView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 탈퇴 후 로그인 화면으로 이동
        if let reasonText = accountCancellationView.writenTextView.text {
            if reasonText != accountCancellationView.placeholder {
                Networking.shared.postLeaveReason(data: reasonText)
            }
        }
        // NOTE: 잠시동안 탈퇴완료 화면 보여주고 로그인 화면으로 화면전환
        // TODO: 계정 및 데이터 모두 삭제
        Networking.shared.deleteUserInfo()
        self.view.addSubview(leaveView)
        leaveView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = true
        } else {
            self.navigationItem.setLeftBarButton(nil, animated: false)
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let main = UIStoryboard.init(name: "Main", bundle: nil)
            let LoginViewController = main.instantiateViewController(identifier: "ViewController") as! ViewController
            LoginViewController.modalPresentationStyle = .fullScreen
            self.present(LoginViewController, animated: false)
        }
    }
}
