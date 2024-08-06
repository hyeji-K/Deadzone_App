//
//  VisitReasonViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit

final class VisitReasonViewController: UIViewController, DataSendDelegate {
    
    private let visitReasonView = VisitReasonView()
    private let secondVisitReasonView = SecondVisitReasonView()
    private var originalPosition: CGPoint?
    private let dismissVisitReasonViewController: Notification.Name = Notification.Name("VisitReasonViewController")
    
    var feeling: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 위로 올라오는 애니메이션
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.visitReasonView.snp.updateConstraints { make in
                make.height.equalTo(640)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: dismissVisitReasonViewController, object: nil)
    }
    
    private func setupView() {
        self.view.addSubview(visitReasonView)
        visitReasonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        visitReasonView.feelingTableView.separatorStyle = .none
        
        visitReasonView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        secondVisitReasonView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        visitReasonView.addGestureRecognizer(panGestureRecognizer)
        
        self.visitReasonView.feeling = self.feeling
        self.visitReasonView.dataDelegate = self
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        // 선택한 감정은 사용자 정보 데이터베이스에 추가하여 저장 후 화면전환
        guard let feeling else { return }
        Networking.shared.updateUserInfo(dataName: .feeling, data: feeling)
        
        self.view.addSubview(secondVisitReasonView)
        secondVisitReasonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(585)
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
    
    func sendData(data: String?) {
        feeling = data
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        guard let reason = secondVisitReasonView.writenTextView.text else { return }
        if reason != secondVisitReasonView.placeholder {
            self.dimissViewController()
        }
    }

}
