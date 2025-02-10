//
//  JournalViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/08/10.
//

import UIKit
import SnapKit

final class JournalViewController: UIViewController {
    
    private let journalView = JournalView()
    var mainImage: String?
    var subImage: String?
    private var originalPosition: CGPoint?
    private let dismissVelocityThreshold: CGFloat = 1000

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadImage()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateView()
        UIView.animate(withDuration: 3, delay: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .clear
        self.view.addSubview(journalView)
        
        journalView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func updateView() {
        journalView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(44)
        }
    }
    
    private func loadImage() {
        guard let mainImage, let subImage else { return }
        self.journalView.configure(mainImageUrl: mainImage, subImageUrl: subImage)
    }
    
    private func setupGestureRecognizer() {
        // 격일간지 dismiss
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureTapped))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        // 노크 기능
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(knockViewTapped))
        self.journalView.knockView.addGestureRecognizer(tapGesture)
    }
    
    private func dismissViewController() {
        journalView.dismissBottomSheet {
            self.dismiss(animated: false)
        }
    }
    
    // 격일간지 pan을 이용하여 dismiss
    @objc private func panGestureTapped(_ panGesture: UIPanGestureRecognizer) {
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
                UIView.animate(withDuration: 1, animations: {
                    self.view.center = originalPosition
                })
            }
            
        default:
            return
        }
    }
    
    @objc private func knockViewTapped(_ sender: UITapGestureRecognizer) {
        // 노크로 동일한 이유를 구독하고 있는 사용자에게 푸시 보내기
        // 하루 1회 허용
    }
}

extension JournalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
