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
        self.view.backgroundColor = .white
        self.view.addSubview(thirdOnboardView)
        thirdOnboardView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        thirdOnboardView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 홈 화면으로 화면 전환 
    }
    
}
