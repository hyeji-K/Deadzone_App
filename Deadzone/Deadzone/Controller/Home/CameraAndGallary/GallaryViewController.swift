//
//  GallaryViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/30.
//

import UIKit
import Photos

final class GallaryViewController: UIViewController {
    
    private let gallaryView = GallaryView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = DZColor.grayColor100
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    var asset: PHFetchResult<PHAsset>
    let imageManager = PHCachingImageManager()
    private let cellWidth = UIScreen.main.bounds.width / 3
    
    private var selectedImage: UIImage?
    private var imageData: Data = Data()
    
    init() {
        let phFetchOptions = PHFetchOptions()
        phFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.asset = PHAsset.fetchAssets(with: phFetchOptions)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    private func setupView() {
        self.view.backgroundColor = DZColor.black
        self.view.addSubview(gallaryView)
        self.view.addSubview(collectionView)
        self.view.addSubview(indicatorView)
        
        gallaryView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(73)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(gallaryView.snp.bottom)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.register(GallaryCell.self, forCellWithReuseIdentifier: GallaryCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view.bringSubviewToFront(indicatorView)
        
        gallaryView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
//        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)

//        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
//            let homeVC = HomeViewController()
//            homeVC.modalPresentationStyle = .fullScreen
//            let sceneDelegate = UIApplication.shared.delegate as! SceneDelegate
//            sceneDelegate.window?.rootViewController?.present(homeVC, animated: true, completion: nil)
//        })
        
        // MARK: 선택한 사진 저장하고 화면 전환
        // TODO: 인디케이터 
        indicatorView.startAnimating()
        Networking.shared.imageUpload(id: UUID().uuidString, imageData: self.imageData) { url in
            guard let archiveName = UserDefaults.standard.string(forKey: "archiveName") else { return }
            Networking.shared.updateArchive(name: archiveName, imageUrl: url)
            
            DispatchQueue.main.async {
                guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }
                self.indicatorView.stopAnimating()
                self.dismiss(animated: false) {
                    // dismiss 완료 후 아카이브 화면 띄우기
                    let archiveListViewController = ArchiveListViewController()
                    presentingViewController.pushViewController(archiveListViewController, animated: true)
                }
            }
        }
    }
}

extension GallaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GallaryCell.identifier, for: indexPath) as! GallaryCell
        
        let asset = self.asset[indexPath.item]
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: cellWidth, height: cellWidth), contentMode: .aspectFill, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                guard let image else { return }
                cell.configure(image: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GallaryCell.identifier, for: indexPath) as! GallaryCell
        print(indexPath.item)
//        print(asset[indexPath.item])
        let asset = self.asset[indexPath.item]
//        asset.getURL { responseURL in
//            print(responseURL)
//        }
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: cellWidth, height: cellWidth), contentMode: .aspectFill, options: nil) { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                guard let image else { return }
                let data = image.pngData()! as NSData
                self.selectedImage = image
                self.imageData = data as Data
//                print(self.imageData)
            }
        }
    }
}

extension GallaryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.asset) else { return }
        
        self.asset = changes.fetchResultAfterChanges
        
        DispatchQueue.main.async {
            if changes.hasIncrementalChanges {
                self.collectionView.performBatchUpdates {
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        self.collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        self.collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                }
            } else {
                self.collectionView.reloadData()
            }
        }
    }
}

extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
