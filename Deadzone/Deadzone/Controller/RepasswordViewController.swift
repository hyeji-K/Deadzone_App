//
//  RepasswordViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit
import FirebaseAuth

final class RepasswordViewController: UIViewController {
    
    private let repasswordView = RepasswordView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(repasswordView)
        repasswordView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        repasswordView.resettingButton.addTarget(self, action: #selector(resettingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func resettingButtonTapped(_ sender: UIButton) {
        // 이메일로 존재하는 사용자인지 확인 후 화면 전환
        print(Auth.auth().currentUser?.email)
        // 이전에 로그인한 이메일이 저장되어 있음
        if Auth.auth().currentUser?.email == repasswordView.emailTextField.text {
            repasswordView.emailTextField.backgroundColor = DZColor.grayColor300
            repasswordView.checkEmailLabel.isHidden = true
            let setpasswordViewController = SetpasswordViewController()
            setpasswordViewController.modalPresentationStyle = .fullScreen
            self.present(setpasswordViewController, animated: false)
        } else {
            repasswordView.emailTextField.backgroundColor = DZColor.red02
            repasswordView.checkEmailLabel.isHidden = false
        }
    }
}
