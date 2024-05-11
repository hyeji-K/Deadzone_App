//
//  HomeViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit
import SnapKit

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
        reloadView()
        
        // 1. ActivitySelectedViewController에서 활동 선택 후 홈 화면에 반영
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissNotification), name: NSNotification.Name("ActivitySelectedViewController"), object: nil)
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
        
        homeView.cdplayerImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.fashion01ImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.fashion02ImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.iceCoffeeImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.readingImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.meditationImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        homeView.wastedImageButton.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
    }
    
    // 업데이트 된 활동을 읽어와서 홈 화면에 반영
    private func reloadView() {
        Networking.shared.getActivity { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                var activitys: [String: Bool] = [:]
                for (key, value) in snapshot {
                    activitys.updateValue((value as! Int).boolValue, forKey: key)
                }
                self.homeView.cdplayerImageButton.isHidden = activitys["cdplayer"]!
                self.homeView.fashion01ImageButton.isHidden = activitys["fashion01"]!
                self.homeView.fashion02ImageButton.isHidden = activitys["fashion02"]!
                self.homeView.tableImageView.isHidden = activitys["table"]!
                self.homeView.iceCoffeeImageButton.isHidden = activitys["iceCoffee"]!
                self.homeView.readingImageButton.isHidden = activitys["reading"]!
                self.homeView.meditationImageButton.isHidden = activitys["meditation"]!
                self.homeView.wastedImageButton.isHidden = activitys["wasted"]!
                self.view.setNeedsDisplay()
            }
        }
    }

    @objc private func addAssetButtonTapped(_ sender: UIButton) {
        let activitySelectedViewController = ActivitySelectedViewController()
        activitySelectedViewController.modalPresentationStyle = .overCurrentContext
        activitySelectedViewController.activityDelegate = self
        self.present(activitySelectedViewController, animated: false)
    }
    
    @objc private func archiveButtonTapped(_ sender: UIButton) {
        // NOTE: 활동을 선택하지 않았을 때엔 알럿
        Networking.shared.getUserInfo { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let userInfo: User = try decoder.decode(User.self, from: data)
                    
                    if userInfo.archive.first == "" {
                        let alert = UIAlertController(title: nil, message: "활동을 선택하지 않았습니다.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .cancel)
                        alert.addAction(okAction)
                        self.present(alert, animated: false)
                    } else {
                        DispatchQueue.main.async {
                            let archiveListViewController = ArchiveListViewController()
                            self.navigationController?.pushViewController(archiveListViewController, animated: true)
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 2. ActivitySelectedViewController에서 활동 선택 후 홈 화면에 반영
    @objc private func didDismissNotification(_ notification: Notification) {
        reloadView()
    }
    
    // Activity 터치 시 카메라 열기
    @objc private func activityImageButtonTapped(_ sender: UIButton) {
//        let pickerController = UIImagePickerController()
//        pickerController.sourceType = .camera
////        pickerController.delegate = self
//        self.present(pickerController, animated: false)
        
        if let archiveName = sender.accessibilityIdentifier {
            UserDefaults.standard.setValue(archiveName, forKey: "archiveName")
        }
        let cameraViewController = CameraViewController()
        self.navigationController?.pushViewController(cameraViewController, animated: false)
    }
}

extension HomeViewController: ActivityDelegate {
    func newActivityButtonTapped(_ activitySelectedVC: ActivitySelectedViewController) {
        activitySelectedVC.dismiss(animated: true) {
            let activitySelectedViewController = NewActivityRequestViewController()
            self.navigationController?.pushViewController(activitySelectedViewController, animated: true)
        }
    }
}
