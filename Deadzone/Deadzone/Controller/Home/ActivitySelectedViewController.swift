//
//  ActivitySelectedViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/18.
//

import UIKit

final class ActivitySelectedViewController: UIViewController {
    
    private let activitySelectedView = ActivitySelectedView()
    private var originalPosition: CGPoint?
    private let dismissActivitySelectedViewController: Notification.Name = Notification.Name("ActivitySelectedViewController")

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
        
        activitySelectedView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        activitySelectedView.newActivityButton.addTarget(self, action: #selector(newActivityButtonTapped), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        activitySelectedView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        // 1. 선택한 활동 데이터베이스에 저장 후 dismiss
        let activitys = activitySelectedView.activitys
        Networking.shared.createActivity(activityCount: activitys.count, activitys: activitys)
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
    
    @objc private func newActivityButtonTapped(_ sender: UIButton) {
        // TODO: 새로운 활동 요청
        let activitySelectedViewController = NewActivityRequestViewController()
        let navigationController = UINavigationController(rootViewController: activitySelectedViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
//            navigationController.pushViewController(navigationController, animated: true)
    }
    
    // 바텀시트 밀어서 dismiss
    // TODO: 위로 이동 안되도록 수정하기
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.originalPosition = view.center
        case .changed:
            let translation = panGesture.translation(in: view)
            self.view.frame.origin = CGPoint(x: 0, y: translation.y)
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
}
