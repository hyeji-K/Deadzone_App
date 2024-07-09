//
//  SettingViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit
import MessageUI

final class SettingViewController: UIViewController {
    
    private let settingView = SettingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.title = "SETTING"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        settingView.tableView.separatorStyle = .none
        
        settingView.delegate = self
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingViewController: SettingDelegate, MFMailComposeViewControllerDelegate {
    func showDetailView(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let userInfoSettingViewController = UserInfoSettingViewController()
            self.navigationController?.pushViewController(userInfoSettingViewController, animated: true)
        case 1:
            // 알림
            let alertSettingViewController = AlertSettingViewController()
            self.navigationController?.pushViewController(alertSettingViewController, animated: true)
        case 2:
            let askViewController = AskViewController()
            self.navigationController?.pushViewController(askViewController, animated: true)
            // NOTE: 메일 형식
//            if MFMailComposeViewController.canSendMail() {
//                let composeViewController = MFMailComposeViewController()
//                composeViewController.mailComposeDelegate = self
//                
//                let bodyString = """
//                                                 -------------------
//                                                 
//                                                 Device Model : \(self.getDeviceIdentifier())
//                                                 Device OS : \(UIDevice.current.systemVersion)
//                                                 App Version : \(self.getCurrentVersion())
//                                                 
//                                                 -------------------
//                                                    이곳에 내용을 작성해주세요.
//                                                
//                                                
//                                                """
//                composeViewController.setToRecipients(["alreadyzone@gmail.com"])
//                composeViewController.setSubject("<deadzone> 문의")
//                composeViewController.setMessageBody(bodyString, isHTML: false)
//                
//                self.present(composeViewController, animated: true, completion: nil)
//            } else {
//                // 메일 보내기 실패
//                let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
//                let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
//                    // 앱스토어로 이동하기(Mail)
//                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                }
//                let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
//                
//                sendMailErrorAlert.addAction(goAppStoreAction)
//                sendMailErrorAlert.addAction(cancleAction)
//                self.present(sendMailErrorAlert, animated: true, completion: nil)
//            }
        case 3:
            // 이용약관
            print()
        case 4:
            // 체크아웃
            let checkoutViewController = CheckoutViewController()
            self.navigationController?.pushViewController(checkoutViewController, animated: true)
        default:
            print()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
