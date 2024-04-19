//
//  OnboardViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit

final class OnboardViewController: UIViewController {
    
    private let onboardView = OnboardView()
    private var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(onboardView)
        onboardView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        onboardView.nicknameTextField.delegate = self
        onboardView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        // 파이어베이스 데이터베이스에 닉네임 저장 후 화면 전환
        if nickname != nil {
            guard let nickname else { return }
            Networking.shared.updateUserInfo(dataName: .nickname, data: nickname)
            let secondOnboardViewController = SecondOnboardViewController()
            secondOnboardViewController.modalPresentationStyle = .fullScreen
            self.present(secondOnboardViewController, animated: false)            
        }
    }
}

extension OnboardViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        nickname = textField.text
    }
}
