//
//  JournalViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/08/10.
//

import UIKit
import SafariServices

struct Journal: Decodable {
    let mainImageUrl: String
    let subImageUrl: String
}

final class JournalViewController: UIViewController {
    
    private let journalView = JournalView()
    var mainImage: String?
    var subImage: String?
    private var originalPosition: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
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
        
        guard let mainImage, let subImage else { return }
        self.journalView.configure(mainImageUrl: mainImage, subImageUrl: subImage)
        
        // dismiss
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureTapped))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        let termsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsOfAgreeToTermsButtonTapped))
//        self.journalView.knockView.addGestureRecognizer(termsTapGestureRecognizer)
        self.journalView.openChatLinkView.addGestureRecognizer(termsTapGestureRecognizer)
    }
    
    private func updateView() {
        journalView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(44)
        }
    }
    
    // 격일간지 pan 버전
    @objc private func panGestureTapped(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            self.originalPosition = view.center
            print()
        case .changed:
            print()
            let translation = panGesture.translation(in: view)
            if translation.y < 0 {
                return
            } else {
//                self.view.frame.origin = CGPoint(x: 0, y: translation.y)
            }
        case .ended:
            guard let originalPosition = self.originalPosition else { return }
            let velocity = panGesture.velocity(in: view)
            guard velocity.y >= 1000 else {
                UIView.animate(withDuration: 1, animations: {
                    self.view.center = originalPosition
                })
                return
            }
            
            UIView.animate(withDuration: 1,
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
    
    @objc private func detailsOfAgreeToTermsButtonTapped(_ sender: UITapGestureRecognizer) {
        // 오픈채팅링크를 통해 오픈채팅방 접속
        // https://open.kakao.com/o/gOWhJAMg
        guard let url = URL(string: "https://open.kakao.com/o/gOWhJAMg") else { return }
        let safari = SFSafariViewController(url: url)
        self.present(safari, animated: false)
    }
}

extension JournalViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
