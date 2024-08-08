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
    private let dismissActivitySelectedViewController: Notification.Name = Notification.Name("ActivitySelectedViewController")
    
    weak var activityDelegate: ActivityDelegate?
    var activityInit: Bool?
    var selectedActivitys: [String: Bool] = [:]
    var activitys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 위로 올라오는 애니메이션 
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.activitySelectedView.snp.updateConstraints { make in
                make.height.equalTo(364)
            }
            self?.view.layoutIfNeeded()
        }
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
//            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalToSuperview()
        }
        guard let activityInit = activityInit else { return }
        
        if activityInit {
            // 활동을 처음 선택할 때
        } else {
            // 활동을 변경할 때
            self.getSelectedActivity()
            self.activitySelectedView.activityInit = false
            self.activitySelectedView.subTitleLabel.text = "활동을 변경하면, 기존에 선택한 활동은 저장되지 않아요."
            self.activitySelectedView.subTitleLabel.isHidden = false
            self.activitySelectedView.selectedActivitys = self.selectedActivitys
            self.activitySelectedView.activitys = self.activitys
            print(" 컨트롤러에서 가져올떄 \(self.activitys)")
        }
        
        activitySelectedView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        activitySelectedView.newActivityButton.addTarget(self, action: #selector(newActivityButtonTapped), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        activitySelectedView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func getSelectedActivity() {
        for (activity, value) in self.selectedActivitys {
            if !value {
                if activity == "fashion02" || activity == "table" {
                    continue
                }
                self.activitys.append(activity)
            }
        }
    }
    
    private func dimissViewController() {
        UIView.animate(withDuration: 0.3,
            animations: {
                self.view.frame.origin = CGPoint(
                    x: self.view.frame.origin.x,
                    y: self.view.frame.size.height
                )
            },
            completion: { (isCompleted) in
                if isCompleted {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        )
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 1. 선택한 활동 데이터베이스에 저장 후 dismiss
        guard let activityInit = activityInit else { return }
        if activityInit {
            // 활동을 처음 선택할 때
            self.activitys = activitySelectedView.activitys
//            guard let activitys = self.activitys else { return }
            Networking.shared.createActivity(activityCount: activitys.count, activitys: activitys)
            Networking.shared.updateUserInfo(dataName: .archiveName, data: "", archive: activitys)
            self.dimissViewController()
        } else {
            // 활동을 변경할 때
            let alert = UIAlertController(title: nil, message: "활동을 변경하면, 기존에 선택한 활동에 대한 데이터는 다시 볼 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { action in
                // NOTE: 기존 기록 삭제하고 새롭게 업데이트
                let newActivitys = self.activitySelectedView.activitys
//                var changeNewActivitys: [String] = []
//                for new in newActivitys {
//                    changeNewActivitys.append(self.changeCatagotyName(name: new))
//                }
                // 0. 변경될 것과 기존 기록 비교해서 변경된 것은 기록 삭제
                var removePrevious = self.activitys
                for i in 0..<self.activitys.count {
                    if newActivitys.contains(self.activitys[i]) {
                        guard let index = removePrevious.firstIndex(of: self.activitys[i]) else { return }
                        removePrevious.remove(at: index)
                    }
                }
                // 1. 기존 기록 삭제
                var changeRemoveActivitys: [String] = []
                for new in removePrevious {
                    changeRemoveActivitys.append(self.changeCatagotyName(name: new))
                }
                var changeNewActivitys: [String] = []
                for c in newActivitys {
                    changeNewActivitys.append(self.changeCatagotyName(name: c))
                }
                if changeRemoveActivitys.count > 0 {
                    Networking.shared.deleteArchiveData(firstArchiveName: changeRemoveActivitys.first!, secondArchiveName: changeRemoveActivitys.last ?? nil)
                    // 2. 새롭게 업데이트
                    Networking.shared.createActivity(activityCount: changeNewActivitys.count, activitys: changeNewActivitys)
                    Networking.shared.updateUserInfo(dataName: .archiveName, data: "", archive: changeNewActivitys)
                    self.activitys = changeNewActivitys
                }
                self.dimissViewController()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: false)
        }
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
    
    // 바텀시트 밀어서 dismiss
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.originalPosition = view.center
        case .changed:
            let translation = panGesture.translation(in: view)
            if translation.y < 0 {
                return
            } else {
                self.view.frame.origin = CGPoint(x: 0, y: translation.y)
            }
        case .ended:
            guard let originalPosition = self.originalPosition else { return }
            let velocity = panGesture.velocity(in: view)
            guard velocity.y >= 1000 else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = originalPosition
                })
                return
            }
            
            UIView.animate(withDuration: 0.2,
                animations: {
                    self.view.frame.origin = CGPoint(
                        x: self.view.frame.origin.x,
                        y: self.view.frame.size.height
                    )
                },
                completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            )
        default:
            return
        }
    }
    
    func changeCatagotyName(name: String) -> String {
        switch name {
        case "music":
            return "음악"
        case "cafe":
            return "카페"
        case "meditation":
            return "명상"
        case "reading":
            return "독서"
        case "drinking":
            return "음주"
        case "fashion01":
            return "패션"
        default:
            return ""
        }
    }
}
