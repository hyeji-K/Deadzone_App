//
//  SetpasswordViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit

final class SetpasswordViewController: UIViewController {
    
    private let setpasswordView = SetpasswordView()
    private var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(setpasswordView)
        setpasswordView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        setpasswordView.newPasswordTextField.delegate = self
        
        setpasswordView.passwordEyeButton.addTarget(self, action: #selector(passwordEyeButtonTapped), for: .touchUpInside)
        setpasswordView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
            setpasswordView.passwordEyeButton.setImage(DZImage.passDefault, for: .normal)
            setpasswordView.newPasswordTextField.isSecureTextEntry = true
        } else {
            setpasswordView.passwordEyeButton.setImage(DZImage.passActive, for: .normal)
            setpasswordView.newPasswordTextField.isSecureTextEntry = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 비밀번호 재설정 서버와 연동 후 로그인 화면으로 화면 전환
        guard let password else { return }
        if password.isValidPassword() {
            // MARK: This operation is sensitive and requires recent authentication. Log in again before retrying this request.
            Networking.shared.setPassword(newPassword: password) { result in
                switch result {
                case .success(let data):
                    let main = UIStoryboard.init(name: "Main", bundle: nil)
                    let LoginViewController = main.instantiateViewController(identifier: "ViewController") as! ViewController
                    LoginViewController.modalPresentationStyle = .fullScreen
                    self.present(LoginViewController, animated: false)
                case .failure(let error):
                    break
                }
            }
        } else {
            self.setpasswordView.checkPasswordLabel.isHidden = false
        }
    }
}

extension SetpasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pw = textField.text else { return }
        if pw.isValidPassword() {
            setpasswordView.checkPasswordLabel.isHidden = true
            setpasswordView.newPasswordTextField.isCorrecting(value: true)
            password = pw
        } else {
            setpasswordView.newPasswordTextField.isCorrecting(value: false)
            setpasswordView.checkPasswordLabel.isHidden = false
        }
    }
}
