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
        repasswordView.emailTextField.delegate = self
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
                    // NOTE: 패스워드 재설정 메일 보내기
                    Networking.shared.sendEmailSetPassword { result in
                        self.showToastMessage()
                    }
                    
//                    let setpasswordViewController = SetpasswordViewController()
//                    self.navigationController?.pushViewController(setpasswordViewController, animated: false)
                } else {
                    // TODO: 존재하지 않는 이메일입니다.와 같은 문구 추가
                    self.repasswordView.emailTextField.isCorrecting(value: false)
                    self.repasswordView.checkEmailLabel.isHidden = false
                }
            }
        }
    }
    private func showToastMessage() {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .systemGray.withAlphaComponent(0.8)
        toastLabel.textColor = .white
        toastLabel.font = DZFont.subText12
        toastLabel.textAlignment = .center
        toastLabel.text = "메일을 보냈습니다."
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }
        
        UIView.animate(withDuration: 2, delay: 1.5, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }
    }
}

extension RepasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        repasswordView.checkEmailLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
            // 이메일 형식 확인
        if text.isValidEmail() {
            repasswordView.checkEmailLabel.isHidden = true
            repasswordView.emailTextField.isCorrecting(value: true)
        } else {
            repasswordView.checkEmailLabel.isHidden = false
            repasswordView.emailTextField.isCorrecting(value: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if repasswordView.emailTextField.text != "" {
            repasswordView.emailTextField.resignFirstResponder()
            return true
        }
        return false
    }
}
