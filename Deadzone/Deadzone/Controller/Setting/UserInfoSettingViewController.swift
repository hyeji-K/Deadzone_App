//
//  UserInfoSettingViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit

final class UserInfoSettingViewController: UIViewController {
    
    private let userInfoSettingView = UserInfoSettingView()
    private var userInfo: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        fetch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissNotification), name: NSNotification.Name("VisitReasonViewController"), object: nil)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "개인정보 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(userInfoSettingView)
        userInfoSettingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.userInfoSettingView.visitReasonButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        // NOTE: 닉네임 변경 유무 확인 후 변경되었으면 사용자 정보 업데이트
        // 닉네임 값이 nil일때는 기존의 닉네임으로 유지
        if self.userInfoSettingView.nickNameTextField.text == "" {
            self.navigationController?.popViewController(animated: true)
        } else {
            guard let user = self.userInfo else { return }
            if user.nickname != self.userInfoSettingView.nickNameTextField.text {
                Networking.shared.updateUserInfo(dataName: .nickname, data: self.userInfoSettingView.nickNameTextField.text!)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func tapGesture() {
        // 방문 이유 바텀 시트 보여주기
        let visitReasonViewContoller = VisitReasonViewController()
        visitReasonViewContoller.feeling = self.userInfoSettingView.visitReasonTextField.text
        visitReasonViewContoller.modalPresentationStyle = .overCurrentContext
        self.present(visitReasonViewContoller, animated: false)
    }
    
    private func fetch() {
        Networking.shared.getUserInfo { userInfo in
            self.userInfo = userInfo
            self.userInfoSettingView.nickNameTextField.text = userInfo.nickname
            self.userInfoSettingView.emailTextField.text = userInfo.email
            self.userInfoSettingView.visitReasonTextField.text = userInfo.feeling
        }
    }
    
    @objc private func didDismissNotification(_ notification: Notification) {
        fetch()
    }
}
