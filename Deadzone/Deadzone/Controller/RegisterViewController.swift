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
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        registerView.passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonTapped), for: .touchUpInside)
        registerView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
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
        // 버튼 클릭 시
        // 1. 이메일주소 형식 확인
        // 2. 비밀번호 형식 확인
        // 회원가입 완료 -> 로그인 화면으로 이동
//        let onboardViewController = OnboardViewController()
//        onboardViewController.modalPresentationStyle = .fullScreen
//        self.present(onboardViewController, animated: false)
        
        if registerView.emailTextField.text != nil && registerView.passwordTextField.text != nil {
            guard let email, let password else { return }
            Networking.shared.createUser(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    // 완료 시 닉네임 입력 화면으로 이동
                    let onboardViewController = OnboardViewController()
                    onboardViewController.modalPresentationStyle = .fullScreen
                    self.present(onboardViewController, animated: false)
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
        print("시작")
        if textField == registerView.passwordTextField {
            textField.text?.removeAll()            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField.text == registerView.emailTextField.text {
            // 이메일 형식 확인
            if text.isValidEmail() {
                print("이메일 입니다.")
                email = textField.text
                registerView.emailErrorCheckLabel.isHidden = true
                registerView.emailTextField.backgroundColor = DZColor.grayColor300
            } else {
                registerView.emailErrorCheckLabel.isHidden = false
                registerView.emailTextField.backgroundColor = DZColor.red02
            }
        } else {
            // 비밀번호 형식 확인
            if text.isValidPassword() {
                password = textField.text
                print("비밀번호 입니다.")
                registerView.passwordErrorCheckLabel.isHidden = true
                registerView.passwordTextField.backgroundColor = DZColor.grayColor300
            } else {
                // 비밀번호 형식을 확인하세요
                registerView.passwordErrorCheckLabel.isHidden = false
                registerView.passwordTextField.backgroundColor = DZColor.red02
//                let alert = UIAlertController(title: "", message: "비밀번호는 영문과 숫자 조합, 8자리 이상", preferredStyle: .alert)
//                let action = UIAlertAction(title: "확인", style: .default)
//                alert.addAction(action)
//                self.present(alert, animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(textField.text)
        // 이메일주소 필드일때 이메일 형식이 맞는지 확인
        // 비밀번호 필드일때 비밀번호 형식이 맞는지 확인
        return true
    }
}
