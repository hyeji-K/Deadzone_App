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
    
    var selectedActivitys: [String: Bool] = [:]
    
    private let tutorialView = TutorialView()
    private var tapCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        reloadView()
        
        // 1. ActivitySelectedViewController에서 활동 선택 후 홈 화면에 반영
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissNotification), name: NSNotification.Name("ActivitySelectedViewController"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
        self.navigationController?.navigationBar.tintColor = DZColor.black
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.settings, style: .plain, target: self, action: #selector(settingButtonTapped))
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
        
        
        // NOTE: 튜토리얼 - 회원가입 후 처음 한 번
        if UserDefaults.standard.bool(forKey: "Tutorial") {
            UserDefaults.standard.setValue(false, forKey: "Tutorial")
            self.view.addSubview(tutorialView)
            tutorialView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped))
        self.tutorialView.addGestureRecognizer(tapGesture)
    }
    
    // 업데이트 된 활동을 읽어와서 홈 화면에 반영
    private func reloadView() {
        Networking.shared.getActivity { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                for (key, value) in snapshot {
                    self.selectedActivitys.updateValue((value as! Int).boolValue, forKey: key)
                }
                self.homeView.cdplayerImageButton.isHidden = self.selectedActivitys["music"]!
                self.homeView.fashion01ImageButton.isHidden = self.selectedActivitys["fashion01"]!
                self.homeView.fashion02ImageButton.isHidden = self.selectedActivitys["fashion02"]!
                self.homeView.tableImageView.isHidden = self.selectedActivitys["table"]!
                self.homeView.iceCoffeeImageButton.isHidden = self.selectedActivitys["cafe"]!
                self.homeView.readingImageButton.isHidden = self.selectedActivitys["reading"]!
                self.homeView.meditationImageButton.isHidden = self.selectedActivitys["meditation"]!
                self.homeView.wastedImageButton.isHidden = self.selectedActivitys["drinking"]!
                self.view.setNeedsDisplay()
            }
        }
    }
    
    private func isExistSelectedActivity(completion: @escaping (Bool) -> Void) {
        Networking.shared.getUserInfo { userInfo in
            if userInfo.archive.first == "" {
                completion(false)
                
            } else {
                completion(true)
            }
        }
    }

    @objc private func addAssetButtonTapped(_ sender: UIButton) {
        // NOTE: 활동 선택이 처음인지 아닌지 확인하기 위하여 유저 정보 불러오기
        self.isExistSelectedActivity { result in
            if result {
                // 선택한 활동이 있을 때
                DispatchQueue.main.async {
                    let activitySelectedViewController = ActivitySelectedViewController()
                    activitySelectedViewController.modalPresentationStyle = .overCurrentContext
                    activitySelectedViewController.activityDelegate = self
                    activitySelectedViewController.activityInit = false
                    activitySelectedViewController.selectedActivitys = self.selectedActivitys
                    self.present(activitySelectedViewController, animated: false)
                }
            } else {
                // 선택한 활동이 없을 때
                DispatchQueue.main.async {
                    let activitySelectedViewController = ActivitySelectedViewController()
                    activitySelectedViewController.modalPresentationStyle = .overCurrentContext
                    activitySelectedViewController.activityDelegate = self
                    activitySelectedViewController.activityInit = true
                    self.present(activitySelectedViewController, animated: false)
                }
            }
        }
    }
    
    @objc private func archiveButtonTapped(_ sender: UIButton) {
        // NOTE: 활동을 선택하지 않았을 때엔 알럿
        self.isExistSelectedActivity { result in
            if result {
                DispatchQueue.main.async {
                    let archiveListViewController = ArchiveListViewController()
                    self.navigationController?.pushViewController(archiveListViewController, animated: true)
                }
            } else {
                let alert = UIAlertController(title: nil, message: "활동을 선택하지 않았습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .cancel)
                alert.addAction(okAction)
                self.present(alert, animated: false)
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
    
    @objc private func settingButtonTapped(_ sender: UIButton) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @objc private func tapGestureTapped(_ tapGesture: UITapGestureRecognizer) {
        tapGesture.isEnabled = false
        if self.tapCount == 0 {
            self.tutorialView.assetStackView.isHidden = true
            self.tutorialView.sofaStackView.isHidden = false
            tapGesture.isEnabled = true
        } else if self.tapCount == 1 {
            self.tutorialView.sofaStackView.isHidden = true
            self.tutorialView.archiveStackView.isHidden = false
            tapGesture.isEnabled = true
        } else if self.tapCount == 2 {
            self.tutorialView.archiveStackView.isHidden = true
            self.tutorialView.arrowImageView.isHidden = false
            self.tutorialView.arrowTitleLabel.isHidden = false
            // 화살표 올라가는 애니메이션
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.tutorialView.arrowImageView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(172)
                }
                self?.tutorialView.arrowTitleLabel.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(212)
                }
                self?.view.layoutIfNeeded()
            }
            tapGesture.isEnabled = true
        } else {
            self.tutorialView.isHidden = true
        }
        self.tapCount += 1
    }
}

extension HomeViewController: ActivityDelegate {
    func newActivityButtonTapped(_ activitySelectedVC: ActivitySelectedViewController) {
        activitySelectedVC.dismiss(animated: false) {
            let activitySelectedViewController = NewActivityRequestViewController()
            self.navigationController?.pushViewController(activitySelectedViewController, animated: true)
        }
    }
}
