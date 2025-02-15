//
//  SecondOnboardViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/09.
//

import UIKit

final class SecondOnboardViewController: UIViewController, DataSendDelegate {
    
    private let secondOnboardView = SecondOnboardView()
    private var feeling: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(secondOnboardView)
        secondOnboardView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        secondOnboardView.feelingTableView.separatorStyle = .none
        
        secondOnboardView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        secondOnboardView.dataDelegate = self
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        // 선택한 감정은 사용자 정보 데이터베이스에 추가하여 저장 후 화면전환
        // 감정 선택하지 않으면 다음 화면으로 넘어가지 못하게
        guard let feeling else { return }
        Networking.shared.updateUserInfo(dataName: .feeling, data: feeling)
        let thirdOnboardViewController = ThirdOnboardViewController()
        thirdOnboardViewController.modalPresentationStyle = .fullScreen
        self.present(thirdOnboardViewController, animated: false)
    }
    
    func sendData(data: String?) {
        feeling = data
    }
}
