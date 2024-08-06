//
//  RegisterViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/08.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    private let registerView = RegisterView()
    private var email: String?
    private var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        registerView.passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonTapped), for: .touchUpInside)
        registerView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func passwordEyeButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            registerView.passwordEyeButton.setImage(DZImage.passDefault, for: .normal)
            registerView.passwordTextField.isSecureTextEntry = true
        } else {
            registerView.passwordEyeButton.setImage(DZImage.passActive, for: .normal)
            registerView.passwordTextField.isSecureTextEntry = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 회원가입 완료 -> 사용자 정보(닉네임) 입력 화면으로 이동
        if registerView.emailTextField.text != nil && registerView.passwordTextField.text != nil {
            guard let email, let password else { return }
            Networking.shared.createUser(email: email, password: password) { result in
                switch result {
                case .success(let authEmail):
                    // 완료 시 사용자 생성 및 닉네임 입력 화면으로 이동
                    Networking.shared.createUserInfo(email: authEmail)
                    let termsOfUseViewController = TermsOfUseViewController()
                    self.navigationController?.pushViewController(termsOfUseViewController, animated: false)
                case .failure(.emailAlreadyInUse):
                    break
                case .failure(.invalidEmail):
                    break
                case .failure(.weakPassword):
                    break
                }
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == registerView.passwordTextField {
            textField.text?.removeAll()            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField.text == registerView.emailTextField.text {
            // 이메일 형식 확인
            if text.isValidEmail() {
                email = textField.text
                registerView.emailErrorCheckLabel.isHidden = true
                registerView.emailTextField.isCorrecting(value: true)
            } else {
                registerView.emailErrorCheckLabel.isHidden = false
                registerView.emailTextField.isCorrecting(value: false)
            }
        } else {
            // 비밀번호 형식 확인
            if text.isValidPassword() {
                password = textField.text
                registerView.passwordErrorCheckLabel.isHidden = true
                registerView.passwordTextField.isCorrecting(value: true)
            } else {
                registerView.passwordErrorCheckLabel.isHidden = false
                registerView.passwordTextField.isCorrecting(value: false)
//                let alert = UIAlertController(title: "", message: "비밀번호는 영문과 숫자 조합, 8자리 이상", preferredStyle: .alert)
//                let action = UIAlertAction(title: "확인", style: .default)
//                alert.addAction(action)
//                self.present(alert, animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(textField.text)
        return true
    }
}
