//
//  ActivitySelectedViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/18.
//

import UIKit

protocol ActivityDelegate: AnyObject {
    func newActivityButtonTapped(_ activitySelectedVC: ActivitySelectedViewController)
}

final class ActivitySelectedViewController: UIViewController {
    
    private let activitySelectedView = ActivitySelectedView()
    private var originalPosition: CGPoint?
    private let dismissVelocityThreshold: CGFloat = 1000
    
    // 선택된 Activity가 있다면 DoneButton 활성화
    var selectedActivities: [String] = [] {
        didSet {
            updateDoneButtonState()
            updateSubTitleState()
        }
    }
    var activityInit: Bool = true
    private var originSelectedActivities: [String] = []
    
    // NOTE: 홈 화면에 변경사항을 바로 반영하기 위한 Notification
    private let dismissActivitySelectedViewController: Notification.Name = Notification.Name("ActivitySelectedViewController")
    
    weak var activityDelegate: ActivityDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDelegates()
        setupPanGestures()
        setupActions()
        
        loadSavedActivities()
        setupSubTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 뷰가 위로 올라오는 애니메이션
        activitySelectedView.showBottomSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: dismissActivitySelectedViewController, object: nil)
    }
    
    private func setupView() {
        self.view.addSubview(activitySelectedView)
        activitySelectedView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func setupDelegates() {
        activitySelectedView.selectionDelegate = self
    }
    
    private func setupActions() {
        activitySelectedView.doneButton.addTarget(self,
                                                  action: #selector(doneButtonTapped),
                                                  for: .touchUpInside)
        activitySelectedView.newActivityButton.addTarget(self,
                                                         action: #selector(newActivityButtonTapped),
                                                         for: .touchUpInside)
    }
    
    func setupPanGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handlePanGesture))
        activitySelectedView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func dismissViewController() {
        activitySelectedView.dismissBottomSheet {
            self.dismiss(animated: false)
        }
    }
    
    @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        let velocity = panGesture.velocity(in: view)
        
        switch panGesture.state {
        case .began:
            self.originalPosition = view.center
            
        case .changed:
            if translation.y >= 0 {
                self.view.frame.origin = CGPoint(x: 0, y: translation.y)
            }
            
        case .ended:
            guard let originalPosition = self.originalPosition else { return }
            
            if velocity.y >= dismissVelocityThreshold {
                dismissViewController()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = originalPosition
                })
            }
            
        default:
            return
        }
    }
    
    private func loadSavedActivities() {
        // 저장된 활동 불러오기
//        if let storedRoom = activityManager.getStoredActivities() {
//            // 저장된 활동 중 true인 것만 필터링
//            let selectedActivityTypes = storedRoom.activities.filter { $0.value }.map { $0.key }
//            
//            // ActivityType의 rawValue를 한글 이름으로 변환 후 빈 문자열은 제거
//            selectedActivities = selectedActivityTypes.compactMap { rawValue in
//                guard let activityType = ActivityType(rawValue: rawValue) else { return nil }
//                return activityType.koreanTitle
//            }.filter { $0 != "" }
//            
//            // 데이터가 빈 값이 아닐때
            if !selectedActivities.isEmpty {
                self.activityInit = false
                self.originSelectedActivities = selectedActivities
            }
//        }
    }
    
    private func setupSubTitle() {
        // 데이터 값이 존재할때 subTitle 문구 변경
        if !selectedActivities.isEmpty {
            self.activitySelectedView.changeSubTitle()
        }
    }
    
    private func updateDoneButtonState() {
        activitySelectedView.doneButton.isEnabled = !selectedActivities.isEmpty
    }
    
    private func updateSubTitleState() {
        activitySelectedView.subTitleLabel.isHidden = selectedActivities.isEmpty
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // NOTE: 선택한 활동 데이터베이스에 저장 후 dismiss
        // 처음으로 활동을 선택하는 것인지, 활동을 변경하는 것인지 구분
        if self.activityInit {
            // 활동을 처음 선택할 때
            // 선택한 활동을 데이터베이스에 저장
            Networking.shared.createActivity(activityCount: selectedActivities.count, activitys: selectedActivities)
            Networking.shared.updateUserInfo(dataName: .archiveName, data: "", archive: selectedActivities)
            Networking.shared.updateActivityReport(increaseActivity: selectedActivities, decreaseActivity: [])
            self.dismissViewController()
        } else {
            // 활동 변경일 시에는 알럿 띄어주기
            // 변경되지 않았을때는 알럿 보여주지 않고 dismiss
            // 이전에 선택한 값과 변경된 값을 비교하여 변경사항 확인하기
            let newActivities = self.selectedActivities.filter {
                !self.originSelectedActivities.contains($0)
            }
            if newActivities.count == 0 && self.selectedActivities.count == self.originSelectedActivities.count {
                self.dismissViewController()
                return
            } else {
                let alert = UIAlertController(title: nil, message: "활동을 변경하면, 기존에 선택한 활동에 대한 데이터는 다시 볼 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { action in
                    // NOTE: 기존 기록 삭제하고 새롭게 업데이트
                    self.handleActivityUpdate(selectedActivities: self.selectedActivities)
                    // 0. ["음악"] -> ["독서"]
                    // 1. ["음악"] -> ["음악", "카페"]
                    // 2. ["음악"] -> ["패션", "카페"]
                    // 3. ["패션", "카페"] -> ["패션"]
                    // 4. ["패션", "카페"] -> ["패션", "독서"]
                    // 5. ["패션", "카페"] -> ["음악", "독서"]
                    // 새롭게 추가된 것, 삭제해야할 것, 유지해야할 것
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: false)
            }
        }
    }
    
    private func handleActivityUpdate(selectedActivities: [String]) {
        // 확인 버튼 클릭 시에 기존과 변경되었으면 기존 기록 삭제하고 업데이트
        let newActivities = self.selectedActivities.filter {
            !self.originSelectedActivities.contains($0)
        }
        let originActivities = self.originSelectedActivities.filter {
            !self.selectedActivities.contains($0)
        }
//        let newActivities = self.selectedActivities.filter {
//            self.originSelectedActivities.contains($0)
//        }
        
        // 기존 기록 중에 삭제해야할 것 삭제 - 아카이브 삭제
        if originActivities.count > 0 {
            if originActivities.count == 1 {
                Networking.shared.deleteArchiveData(firstArchiveName: originActivities.first!)
            } else if originActivities.count == 2 {
                Networking.shared.deleteArchiveData(firstArchiveName: originActivities.first!,
                                                    secondArchiveName: originActivities.last!)
            }
        }
        
        // 새롭게 업데이트할 것 - UserInfo, Room, Report
        Networking.shared.createActivity(activityCount: selectedActivities.count,
                                         activitys: selectedActivities)
        Networking.shared.updateUserInfo(dataName: .archiveName,
                                         data: "",
                                         archive: selectedActivities)
        Networking.shared.updateActivityReport(increaseActivity: newActivities,
                                               decreaseActivity: originActivities)
        self.dismissViewController()
    }
    
    @objc private func newActivityButtonTapped(_ sender: UIButton) {
        // 새로운 활동 요청
        activityDelegate?.newActivityButtonTapped(self)
//        let activitySelectedViewController = NewActivityRequestViewController()
//        let navigationController = UINavigationController(rootViewController: activitySelectedViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true)
//            navigationController.pushViewController(navigationController, animated: true)
    }
}

extension ActivitySelectedViewController: ActivitySelectionDelegate {
    var maximumSelectionCount: Int {
        return 2
    }
    
    func numberOfSelectedItems(in collectionView: UICollectionView) -> Int {
        return self.selectedActivities.count
    }
    
    func configureSelection(forActivity activity: String, in collectionView: UICollectionView, at indexPath: IndexPath) {
        // 저장된 활동 목록에 포함되어 있다면 해당 셀 선택
        if self.selectedActivities.contains(activity) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    func activityCollectionView(_ collectionView: ActivitySelectedView, didSelectActivity activity: String) {
        selectedActivities.append(activity)
    }
    
    func activityCollectionView(_ collectionView: ActivitySelectedView, didDeselectActivity activity: String) {
        selectedActivities.remove(at: selectedActivities.firstIndex(of: activity)!)
    }
}
