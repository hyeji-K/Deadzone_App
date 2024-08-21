//
//  AlertSettingViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class AlertSettingViewController: UIViewController {
    
    private let alertSettingView = AlertSettingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.text16]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(alertSettingView)
        alertSettingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        alertSettingView.alertButton.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)
        alertSettingView.knockingButton.addTarget(self, action: #selector(knockingButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func alertButtonTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().requestAuthorization { didAllow, error in
            if didAllow {
                print("알림이 허용되었습니다.")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "기기 알림이 꺼져있어 알림을 켤 수 없습니다.", message: "알림을 받으시려면\n기기 설정에서 알림을 허용해주세요.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "기기 설정", style: .default) { _ in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancelAction)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func knockingButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(DZImage.on, for: .normal)
            UserDefaults.standard.setValue(true, forKey: "knockingButtonSelected")
        } else {
            sender.setImage(DZImage.off, for: .normal)
            UserDefaults.standard.setValue(false, forKey: "knockingButtonSelected")
        }
    }
}
