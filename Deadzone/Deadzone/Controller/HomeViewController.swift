//
//  HomeViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private var addAssetButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.addasset, for: .normal)
        return button
    }()
    
    private var archiveButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.archive, for: .normal)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addAssetButton, archiveButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.settings, style: .plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: DZImage.alarm, style: .plain, target: self, action: .none)
        self.navigationController?.navigationBar.tintColor = DZColor.black
        self.navigationItem.title = "deadzone"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle24]
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(homeView)
        self.view.addSubview(buttonStackView)
        homeView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(39)
        }
        addAssetButton.addTarget(self, action: #selector(addAssetButtonTapped), for: .touchUpInside)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
    }

    @objc private func addAssetButtonTapped(_ sender: UIButton) {
        let activitySelectedViewController = ActivitySelectedViewController()
        activitySelectedViewController.modalPresentationStyle = .overCurrentContext
        self.present(activitySelectedViewController, animated: false)
    }
    
    @objc private func archiveButtonTapped(_ sender: UIButton) {
        
    }
}
