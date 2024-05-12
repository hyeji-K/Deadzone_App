//
//  PhotoViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let addPhotoButton: UIButton = {
        let button = MainButton()
        button.setTitle("기록 추가", for: .normal)
        return button
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = DZColor.grayColor100
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    var photoImageView: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.backgroundColor
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.black
        self.view.addSubview(selectedImageView)
        self.view.addSubview(addPhotoButton)
        self.view.addSubview(indicatorView)
        
        selectedImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addPhotoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(52)
        }
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view.bringSubviewToFront(indicatorView)
        
        selectedImageView.image = photoImageView
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func addPhotoButtonTapped(_ sender: UIButton) {
        indicatorView.startAnimating()
        guard let image = photoImageView else { return }
        let imageData = image.jpegData(compressionQuality: 0.1)!
//        let imageData = image.pngData()! as NSData
        
        guard let archiveName = UserDefaults.standard.string(forKey: "archiveName") else { return }
        Networking.shared.imageUpload(storageName: archiveName, id: UUID().uuidString, imageData: imageData as Data) { url in
            Networking.shared.updateArchive(name: archiveName, imageUrl: url)
            
            self.indicatorView.stopAnimating()
            DispatchQueue.main.async {
                // pop 완료 후 아카이브 화면 띄우기
//                self.navigationController?.popToRootViewController(animated: false)
                let archiveListViewController = ArchiveListViewController()
                self.navigationController?.pushViewController(archiveListViewController, animated: false)
            }
        }
//        guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }
//        self.navigationController?.popToRootViewController(animated: false)
        // pop 완료 후 아카이브 화면 띄우기
//        let archiveListViewController = ArchiveListViewController()
//        presentingViewController.pushViewController(archiveListViewController, animated: true)
    }

}
