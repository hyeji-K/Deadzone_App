//
//  DetailsOfAgreeToTermsViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/07/12.
//

import UIKit

final class DetailsOfAgreeToTermsViewController: UIViewController {
    
    private let detailsOfAgreeToTermsView = DetailsOfAgreeToTermsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "이용약관"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(detailsOfAgreeToTermsView)
        detailsOfAgreeToTermsView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        detailsOfAgreeToTermsView.tableView.separatorStyle = .none
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
