//
//  ViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/03.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let loginView = LoginView()
    private var email: String?
    private var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        loginView.resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        if loginView.emailTextField.text != nil && loginView.passwordTextField.text != nil {
            guard let email, let password else { return }
            Networking.shared.signInApp(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let str):
                    // 로그인 성공 시 홈 화면으로 전환
                    print("로그인 성공!")
                    DispatchQueue.main.async {
                        let main = UIStoryboard.init(name: "Home", bundle: nil)
                        let homeViewController = main.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                        let navigationController = UINavigationController(rootViewController: homeViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self?.present(navigationController, animated: false)
                    }
                case .failure(let error):
                    self?.loginView.checkEmailAndPasswordLabel.isHidden = false
                }
            }
        }
    }
    
    @objc private func resetPasswordButtonTapped(_ sender: UIButton) {
        let repasswordViewController = RepasswordViewController()
        repasswordViewController.modalPresentationStyle = .fullScreen
        self.present(repasswordViewController, animated: false)
    }

    @objc private func registerButtonTapped(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: false)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginView.checkEmailAndPasswordLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == loginView.emailTextField {
            email = textField.text
        } else {
            password = textField.text
        }
    }
}
