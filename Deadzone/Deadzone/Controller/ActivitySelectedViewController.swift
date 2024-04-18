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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.activitySelectedView.snp.updateConstraints { make in
                make.height.equalTo(364)
            }
            self?.view.layoutIfNeeded()
        }
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
        // TODO: 홈 화면 새로고침
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
//        let activitySelectedViewController = NewActivityRequestViewController()
        
    }
    
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
