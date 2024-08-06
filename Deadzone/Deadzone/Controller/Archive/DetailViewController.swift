//
//  DetailViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    var archive: Archive?
    var archiveTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.black
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        guard let archive = archive else { return }
        detailView.photoImageView.setImageURL(archive.imageUrl)
        if !archive.content.isEmpty {
            detailView.npcWordingImageView.isHidden = true
            detailView.titleLabel.text = "그대:"
            detailView.writenTextView.text = archive.content
        }
    }
    
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        // 한번만 실행됨 그 후론 실행되지 않음
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            
//            detailView.captionImageView.snp.makeConstraints { make in
////                make.bottom.equalToSuperview().inset(keyboardHeight)
//                make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
//            }
//            
//            detailView.titleLabel.text = "그대:"
//            detailView.npcWordingImageView.isHidden = true
//            
//            view.layoutIfNeeded()
//        }
//    }
    
//    @objc private func keyboardWillHide(_ notification: Notification) {
//        detailView.captionImageView.snp.makeConstraints { make in
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(34)
//        }
//        view.layoutIfNeeded()
//    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        detailView.writenTextView.resignFirstResponder()
        
        guard let archiveTitle = archiveTitle else { return }
        guard let archive = archive else { return }
        Networking.shared.updateArchiveContent(name: archiveTitle, archive: archive, content: self.detailView.writenTextView.text)
    }
}
