//
//  TermsOfUseViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/07/10.
//

import UIKit
import SafariServices

final class TermsOfUseViewController: UIViewController {
    
    private let termsOfUseView = TermsOfUseView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(termsOfUseView)
        termsOfUseView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        termsOfUseView.agreeToAllTermsButton.addTarget(self, action: #selector(agreeToAllTermsButtonTapped), for: .touchUpInside)
        
        termsOfUseView.agreeToTermsButton.addTarget(self, action: #selector(agreeToTermsButtonTapped), for: .touchUpInside)
        let termsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsOfAgreeToTermsButtonTapped))
        termsOfUseView.detailsOfAgreeToTermsView.addGestureRecognizer(termsTapGestureRecognizer)
        
        termsOfUseView.agreeToPrivacyButton.addTarget(self, action: #selector(agreeToPrivacyButtonTapped), for: .touchUpInside)
        let privacyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsOfAgreeToPrivacyButtonTapped))
        termsOfUseView.detailsOfAgreeToPrivacyView.addGestureRecognizer(privacyTapGestureRecognizer)
        
        termsOfUseView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        
        self.navigationController?.navigationBar.backIndicatorImage = DZImage.back
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = DZImage.back
        self.navigationItem.backButtonDisplayMode = .minimal
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func agreeToAllTermsButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            if !termsOfUseView.agreeToTermsButton.isSelected {
                termsOfUseView.agreeToTermsButton.isSelected.toggle()
            }
            if !termsOfUseView.agreeToPrivacyButton.isSelected {
                termsOfUseView.agreeToPrivacyButton.isSelected.toggle()
            }
            termsOfUseView.doneButton.isEnabled = true
        } else {
            if termsOfUseView.agreeToTermsButton.isSelected {
                termsOfUseView.agreeToTermsButton.isSelected.toggle()
            }
            if termsOfUseView.agreeToPrivacyButton.isSelected {
                termsOfUseView.agreeToPrivacyButton.isSelected.toggle()
            }
            termsOfUseView.doneButton.isEnabled = false
        }
    }
    
    @objc private func agreeToTermsButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            if !termsOfUseView.agreeToAllTermsButton.isSelected && termsOfUseView.agreeToPrivacyButton.isSelected  {
                termsOfUseView.agreeToAllTermsButton.isSelected.toggle()
                termsOfUseView.doneButton.isEnabled = true
            }
        } else {
            if termsOfUseView.agreeToAllTermsButton.isSelected {
                termsOfUseView.agreeToAllTermsButton.isSelected.toggle()
            }
            termsOfUseView.doneButton.isEnabled = false
        }
    }
    
    @objc private func detailsOfAgreeToTermsButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.notion.so/deadzone/80aa3c9bc0ec4c8aa716920ef42cf19e?pvs=4") else { return }
        let safari = SFSafariViewController(url: url)
        safari.navigationItem.title = "이용약관"
        self.navigationController?.pushViewController(safari, animated: true)
//        let detailsOfAgreeToTermsViewController = DetailsOfAgreeToTermsViewController()
//        self.navigationController?.pushViewController(detailsOfAgreeToTermsViewController, animated: false)
    }
    
    @objc private func agreeToPrivacyButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            if !termsOfUseView.agreeToAllTermsButton.isSelected && termsOfUseView.agreeToTermsButton.isSelected  {
                termsOfUseView.agreeToAllTermsButton.isSelected.toggle()
                termsOfUseView.doneButton.isEnabled = true
            }
        } else {
            if termsOfUseView.agreeToAllTermsButton.isSelected {
                termsOfUseView.agreeToAllTermsButton.isSelected.toggle()
            }
            termsOfUseView.doneButton.isEnabled = false
        }
    }
    
    @objc private func detailsOfAgreeToPrivacyButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.notion.so/deadzone/920d1a40c4214dfd8d70319d31da14a8?pvs=4") else { return }
        let safari = SFSafariViewController(url: url)
        safari.navigationItem.title = "개인정보처리 방침"
        self.navigationController?.pushViewController(safari, animated: true)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        let onboardViewController = OnboardViewController()
        onboardViewController.modalPresentationStyle = .fullScreen
        self.present(onboardViewController, animated: false)
    }
}
