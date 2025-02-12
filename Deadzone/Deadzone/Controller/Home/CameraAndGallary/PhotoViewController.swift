//
//  PhotoViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit
import SnapKit

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
        indicator.color = DZColor.backgroundColor
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    var photoImageView: UIImage? {
        didSet {
            selectedImageView.image = photoImageView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        setupActions()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(closeButtonTapped))
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
    }
    
    private func setupActions() {
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func addPhotoButtonTapped(_ sender: UIButton) {
        indicatorView.startAnimating()
        sender.isEnabled = false
        guard let image = photoImageView else { return }
        let imageData = image.jpegData(compressionQuality: 0.6)!
        
        guard let archiveName = UserDefaults.standard.string(forKey: "archiveName") else { return }
        
        Task {
            do {
                let url = try await Networking.shared.imageUpload(storageName: archiveName,
                                                                  id: UUID().uuidString,
                                                                  imageData: imageData)
                Networking.shared.updateArchive(name: archiveName, imageUrl: "\(url)")
                
                // 화면 전환
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    let archiveListViewController = ArchiveListViewController()
                    self.navigationController?.pushViewController(archiveListViewController,
                                                                  animated: false)
                }
            } catch {
                print("업로드 실패: \(error.localizedDescription)")
            }
        }
    }
}
