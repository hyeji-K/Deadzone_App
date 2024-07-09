//
//  ViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/03.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = DZColor.grayColor100
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    private let loginView = LoginView()
    private var email: String?
    private var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(loginView)
        self.view.addSubview(indicatorView)
        loginView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view.bringSubviewToFront(indicatorView)
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        loginView.resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        self.indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        if loginView.emailTextField.text != nil && loginView.passwordTextField.text != nil {
            guard let email, let password else { return }
            Networking.shared.signInApp(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let result):
                    // 로그인 성공 시 홈 화면으로 전환
                    print(result)
                    self?.indicatorView.stopAnimating()
                    DispatchQueue.main.async {
                        let main = UIStoryboard.init(name: "Home", bundle: nil)
                        let homeViewController = main.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                        let navigationController = UINavigationController(rootViewController: homeViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self?.present(navigationController, animated: false)
                    }
                    self?.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.view.isUserInteractionEnabled = true
                    self?.loginView.checkEmailAndPasswordLabel.isHidden = false
                    self?.indicatorView.stopAnimating()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginView.emailTextField.text != "", loginView.passwordTextField.text != "" {
            loginView.passwordTextField.resignFirstResponder()
            return true
        } else if loginView.emailTextField.text != "" {
            loginView.passwordTextField.becomeFirstResponder()
            return true
        }
        return false
    }
}
