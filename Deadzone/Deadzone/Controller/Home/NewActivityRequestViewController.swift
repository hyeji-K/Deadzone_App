//
//  NewActivityRequestViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

final class NewActivityRequestViewController: UIViewController {
    
    private let newActivityRequestView = NewActivityRequestView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(newActivityRequestView)
        newActivityRequestView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        newActivityRequestView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // DB에 저장하면서 화면 dismiss
        guard let requestText = newActivityRequestView.writenTextView.text else { return }
        Networking.shared.postNewActivityRequest(data: requestText)
        self.navigationController?.popViewController(animated: true)
    }
}
