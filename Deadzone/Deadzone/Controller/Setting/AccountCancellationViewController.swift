//
//  AccountCancellationViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AccountCancellationViewController: UIViewController {
    
    private let accountCancellationView = AccountCancellationView()

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
            Networking.shared.postLeaveReason(data: reasonText)            
        }
        // NOTE: 잠시동안 탈퇴완료 화면 보여주고 로그인 화면으로 화면전환
//        UserDefaults.standard.removeObject(forKey: "userId")
        let leaveViewController = LeaveViewController()
        let navigationContoller = UINavigationController(rootViewController: leaveViewController)
        navigationContoller.modalPresentationStyle = .fullScreen
        self.present(navigationContoller, animated: false, completion: nil)
        
        // TODO: 
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let main = UIStoryboard.init(name: "Main", bundle: nil)
            let LoginViewController = main.instantiateViewController(identifier: "ViewController") as! ViewController
            LoginViewController.modalPresentationStyle = .fullScreen
            self.present(LoginViewController, animated: false)
        }
    }
}
