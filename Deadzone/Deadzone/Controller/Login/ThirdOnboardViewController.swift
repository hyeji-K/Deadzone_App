//
//  ThirdOnboardViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit

final class ThirdOnboardViewController: UIViewController {
    
    private let thirdOnboardView = ThirdOnboardView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(thirdOnboardView)
        thirdOnboardView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        thirdOnboardView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        guard let reason = thirdOnboardView.writenTextView.text else { return }
        if reason != thirdOnboardView.placeholder {
            // 이유 DB에 저장 후 홈 화면으로 화면 전환
            Networking.shared.updateUserInfo(dataName: .reason, data: reason)
            let main = UIStoryboard.init(name: "Home", bundle: nil)
            let homeViewController = main.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            let navigationController = UINavigationController(rootViewController: homeViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false)            
        }
    }
}
