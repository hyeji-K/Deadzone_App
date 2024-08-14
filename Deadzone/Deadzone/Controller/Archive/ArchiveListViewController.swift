//
//  ArchiveListViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/19.
//

import UIKit

final class ArchiveListViewController: UIViewController {
    
    private let archiveListView = ArchiveListView()
    private var archiveTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showToastMessage), name: Notification.Name(rawValue: "SaveText"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.archiveListView.indicatorView.startAnimating()
        guard let archiveTitle = self.archiveTitle else { return }
        self.getArchive(archiveName: archiveTitle)
    }
    
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: DZImage.back, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.grayColor100
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.backgroundColor
        self.view.addSubview(archiveListView)
        
        archiveListView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        archiveListView.delegate = self
        
        archiveListView.firstCatagoryButton.addTarget(self, action: #selector(firstCatagoryButtonTapped), for: .touchUpInside)
        archiveListView.secondCatagoryButton.addTarget(self, action: #selector(secondCatagoryButtonTapped), for: .touchUpInside)
        
        fetch()
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func firstCatagoryButtonTapped(_ sender: UIButton) {
        if sender.isEnabled {
            self.archiveListView.indicatorView.startAnimating()
            self.archiveListView.isUserInteractionEnabled = false
            self.archiveListView.firstCatagoryButton.setImage(DZImage.pointBM, for: .normal)
            self.archiveListView.firstCatagoryTitleLabel.textColor = DZColor.black
            self.archiveListView.secondCatagoryButton.setImage(DZImage.defaultBM, for: .normal)
            self.archiveListView.secondCatagoryTitleLabel.textColor = DZColor.subGrayColor100
            
            self.archiveTitle = changeCatagotyName(name: self.archiveListView.firstCatagoryTitleLabel.text!)
            guard let archiveTitle = self.archiveTitle else { return }
            self.getArchive(archiveName: archiveTitle)
            sender.isEnabled = false
            self.archiveListView.secondCatagoryButton.isEnabled = true
        }
    }
    
    @objc private func secondCatagoryButtonTapped(_ sender: UIButton) {
        if sender.isEnabled {
            self.archiveListView.indicatorView.startAnimating()
            self.archiveListView.isUserInteractionEnabled = false
            self.archiveListView.secondCatagoryButton.setImage(DZImage.pointBM, for: .normal)
            self.archiveListView.secondCatagoryTitleLabel.textColor = DZColor.black
            self.archiveListView.firstCatagoryButton.setImage(DZImage.defaultBM, for: .normal)
            self.archiveListView.firstCatagoryTitleLabel.textColor = DZColor.subGrayColor100
            
            self.archiveTitle = changeCatagotyName(name: self.archiveListView.secondCatagoryTitleLabel.text!)
            guard let archiveTitle = self.archiveTitle else { return }
            self.getArchive(archiveName: archiveTitle)
            sender.isEnabled = false
            self.archiveListView.firstCatagoryButton.isEnabled = true
        }
    }
    
    private func fetch() {
        self.archiveListView.indicatorView.startAnimating()
        Networking.shared.getUserInfo { userInfo in
            if userInfo.archive.count == 2 {
                self.archiveListView.firstCatagoryTitleLabel.text = userInfo.archive.first ?? ""
                self.archiveListView.secondCatagoryTitleLabel.text = userInfo.archive.last ?? ""
                self.archiveListView.secondCatagoryButton.isHidden = false
                self.archiveListView.secondCatagoryTitleLabel.isHidden = false
            } else {
                self.archiveListView.firstCatagoryTitleLabel.text = userInfo.archive.first ?? ""
                self.archiveListView.secondCatagoryButton.isHidden = true
                self.archiveListView.secondCatagoryTitleLabel.isHidden = true
            }
            if self.archiveTitle == nil {
                self.archiveTitle = self.changeCatagotyName(name: self.archiveListView.firstCatagoryTitleLabel.text!)
            }
            guard let archiveTitle = self.archiveTitle else { return }
            self.getArchive(archiveName: archiveTitle)
//                    self.archiveListView.archiveTitleList = userInfo.archive
//                    self.view.setNeedsDisplay()
        }
    }
    
    private func getArchive(archiveName: String) {
        Networking.shared.getArchive { snapshot in
            self.archiveListView.archiveList = []
            var allArchiveList: [String: [Archive]] = [:]
            var archiveList: [Archive] = []
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    if snapshot.keys.contains(archiveName) {
                        for (key, value) in snapshot {
                            if key == archiveName {
                                guard let archiveArray = value as? [String: Any] else { return }
                                for (_, value) in archiveArray {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                                    let decoder = JSONDecoder()
                                    let archive: Archive = try decoder.decode(Archive.self, from: data)
                                    archiveList.append(archive)
                                }
                                // NOTE: 생성된 날짜순으로 정렬
                                let sortedArchiveList = archiveList.sorted { $0.createdAt > $1.createdAt }
                                allArchiveList.updateValue(sortedArchiveList, forKey: key)
                                self.archiveListView.archiveList = archiveList.sorted { $0.createdAt > $1.createdAt }
                                guard let archive = allArchiveList["\(archiveName)"] else { return }
                                self.archiveListView.updateSnapshot(reloading: archive)
                            }
                        }
                    } else {
                        self.archiveListView.indicatorView.stopAnimating()
                        self.archiveListView.isUserInteractionEnabled = true
                        self.archiveListView.updateSnapshot()
                    }
                    self.archiveListView.collectionView.reloadData()
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.archiveListView.indicatorView.stopAnimating()
                self.archiveListView.isUserInteractionEnabled = true
                self.archiveListView.updateSnapshot()
            }
        }
    }
    
    @objc private func showToastMessage(_ notification: Notification) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .systemGray.withAlphaComponent(0.8)
        toastLabel.textColor = .white
        toastLabel.font = DZFont.subText12
        toastLabel.textAlignment = .center
        toastLabel.text = "저장되었습니다."
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }
        
        UIView.animate(withDuration: 2, delay: 1.5, options: .curveEaseOut) {
            toastLabel.alpha = 0.0
        } completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }
    }
    
    func changeCatagotyName(name: String) -> String {
        switch name {
        case "음악":
            return "music"
        case "카페":
            return "cafe"
        case "명상":
            return "meditation"
        case "독서":
            return "reading"
        case "음주":
            return "drinking"
        case "패션":
            return "fashion01"
        default:
            break
        }
        return ""
    }
}

extension ArchiveListViewController: ArchiveDelegate {
    func showDetailView(indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.archive = self.archiveListView.archiveList[indexPath.item]
        detailViewController.archiveTitle = self.archiveTitle
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

enum Activity: String {
    case music = "음악"
    case cafe = "카페"
    case meditation = "명상"
    case reading = "독서"
    case drinking = "음주"
    case fashion01 = "패션"
}
