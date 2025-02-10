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
    private let tutorialView = TutorialView()
    private let buttonSetView = HomeButtonSetView()
    private var journal: Journal?
    
    var selectedActivitys: [String: Bool] = [:]
    var selectedActivities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        setupTutorialView()
        setupActions()
        reloadView()
        getImage()
        setupGestureRecognizer()
        
        // 1. ActivitySelectedViewController에서 활동 선택 후 홈 화면에 반영
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissNotification), name: NSNotification.Name("ActivitySelectedViewController"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle]
        self.navigationController?.navigationBar.tintColor = DZColor.black
    }
    
    // 네비게이션바 세팅
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.settings, style: .plain, target: self, action: #selector(settingButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: DZImage.alarm, style: .plain, target: self, action: #selector(alarmButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.black
        self.navigationItem.title = "deadzone"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : DZFont.subTitle24]
    }
    
    // 뷰 세팅
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(homeView)
        self.view.addSubview(buttonSetView)
        
        homeView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        buttonSetView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(39)
        }
    }
    
    private func setupTutorialView() {
        self.view.addSubview(tutorialView)
        tutorialView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        let buttons = [
            homeView.cdplayerImageButton,
            homeView.fashion01ImageButton,
            homeView.fashion02ImageButton,
            homeView.iceCoffeeImageButton,
            homeView.readingImageButton,
            homeView.meditationImageButton,
            homeView.wastedImageButton
        ]
        
        buttons.forEach { button in
            button.addTarget(self, action: #selector(activityImageButtonTapped), for: .touchUpInside)
        }
        
        buttonSetView.addAssetButton.addTarget(self,
                                               action: #selector(addAssetButtonTapped),
                                               for: .touchUpInside)
        buttonSetView.archiveButton.addTarget(self,
                                              action: #selector(archiveButtonTapped),
                                              for: .touchUpInside)
    }
    
    // 격일간지 스와이프 제스처
    private func setupGestureRecognizer() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureTapped))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    // 업데이트 된 활동을 읽어와서 홈 화면에 반영
    private func reloadView() {
        Networking.shared.getActivity { snapshot in
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                for (key, value) in snapshot {
                    self.selectedActivitys.updateValue((value as! Int).boolValue, forKey: key)
                }
                self.updateUI(selectedActivitys: self.selectedActivitys)
            }
        }
    }
    
    private func updateUI(selectedActivitys: [String: Bool]) {
        // 버튼 또는 다른 뷰에 따라 분리된 매핑
        let buttonVisibilityMap: [String: UIButton] = [
            "music": homeView.cdplayerImageButton,
            "fashion01": homeView.fashion01ImageButton,
            "fashion02": homeView.fashion02ImageButton,
            "cafe": homeView.iceCoffeeImageButton,
            "reading": homeView.readingImageButton,
            "meditation": homeView.meditationImageButton,
            "drinking": homeView.wastedImageButton
        ]
        
        let imageViewVisibilityMap: [String: UIImageView] = [
            "table": homeView.tableImageView
        ]
        
        // 버튼 가시성 업데이트
        for (key, button) in buttonVisibilityMap {
            if let isHidden = selectedActivitys[key] {
                button.isHidden = isHidden
            }
        }
        
        // 이미지 뷰 가시성 업데이트
        for (key, imageView) in imageViewVisibilityMap {
            if let isHidden = selectedActivitys[key] {
                imageView.isHidden = isHidden
            }
        }
        
        self.view.setNeedsDisplay()
    }
    
    private func loadSelectedActivity(completion: @escaping ([String]) -> Void) {
        Networking.shared.getUserInfo { userInfo in
            if userInfo.archive == [""] {
                completion([])
            } else {
                completion(userInfo.archive)
            }
        }
    }

    @objc private func addAssetButtonTapped(_ sender: UIButton) {
        // NOTE: 활동 선택이 처음인지 아닌지 확인하기 위하여 유저 정보 불러오기
        self.loadSelectedActivity { result in
            DispatchQueue.main.async {
                let activitySelectedViewController = ActivitySelectedViewController()
                activitySelectedViewController.modalPresentationStyle = .overCurrentContext
                activitySelectedViewController.activityDelegate = self
                activitySelectedViewController.selectedActivities = result
                self.present(activitySelectedViewController, animated: false)
            }
        }
    }
    
    @objc private func archiveButtonTapped(_ sender: UIButton) {
        // NOTE: 활동을 선택하지 않았을 때엔 알럿
        self.loadSelectedActivity { result in
            if !result.isEmpty {
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
    
    // 설정 버튼 클릭 시 설정 화면으로 전환
    @objc private func settingButtonTapped(_ sender: UIButton) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: false)
    }
    
    // 알림 버튼 클릭 시 알림 화면으로 전환
    @objc private func alarmButtonTapped(_ sender: UIButton) {
        let alarmViewController = AlarmViewController()
        self.navigationController?.pushViewController(alarmViewController, animated: false)
    }
    
    // 격일간지 스와이프 버전
    @objc private func swipeGestureTapped(_ swipeGesture: UISwipeGestureRecognizer) {
        if swipeGesture.direction == .up {
            let journalViewController = JournalViewController()
            guard let journal else { return }
            journalViewController.mainImage = journal.mainImageUrl
            journalViewController.subImage = journal.subImageUrl
            journalViewController.modalPresentationStyle = .overCurrentContext
            self.present(journalViewController, animated: false)
        }
    }
    
    private func getImage() {
        Networking.shared.getJournal { journal in
            self.journal = journal
        }
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
