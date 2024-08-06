//
//  ArchiveListView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/19.
//

import UIKit

protocol ArchiveDelegate {
    func showDetailView(indexPath: IndexPath)
}

final class ArchiveListView: UIView {
    
    var delegate: ArchiveDelegate?
    
    var archiveTitleList: [String] = []
    var archiveList: [Archive] = []
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = DZColor.grayColor100
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    var firstCatagoryButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.pointBM, for: .normal)
        button.setImage(DZImage.pointBM, for: .highlighted)
        button.isEnabled = false
        return button
    }()
    
    lazy var firstCatagoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = DZFont.text14
        label.textColor = DZColor.black
        label.text = archiveTitleList.first ?? ""
        return label
    }()
    
    var secondCatagoryButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.defaultBM, for: .normal)
        button.setImage(DZImage.pointBM, for: .highlighted)
        button.isEnabled = true
        return button
    }()
    
    lazy var secondCatagoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = DZFont.text14
        label.textColor = DZColor.subGrayColor100
        label.text = archiveTitleList.last ?? ""
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그대,\n아카이브"
        label.numberOfLines = 2
        label.setLineSpacing(label.text)
        label.font = DZFont.heading
        label.textColor = DZColor.black
        label.textAlignment = .right
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Item = Archive
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(firstCatagoryButton)
        firstCatagoryButton.addSubview(firstCatagoryTitleLabel)
        addSubview(secondCatagoryButton)
        secondCatagoryButton.addSubview(secondCatagoryTitleLabel)
        addSubview(titleLabel)
        addSubview(collectionView)
        collectionView.addSubview(indicatorView)
        
        firstCatagoryButton.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(-15)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        firstCatagoryTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(snp.left).offset(11)
        }
        secondCatagoryButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(firstCatagoryButton.snp.bottom).offset(11)
        }
        secondCatagoryTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(11)
        }
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(19)
            make.top.equalTo(firstCatagoryButton).inset(21)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(firstCatagoryButton.snp.bottom).offset(80)
            make.left.right.bottom.equalToSuperview()
        }
        
        collectionView.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.identifier)
        collectionView.alwaysBounceHorizontal = false
        
        self.dataSource = DataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCell.identifier, for: indexPath) as? ArchiveCell else { return UICollectionViewCell() }
            cell.configure(archive: itemIdentifier)
            self.indicatorView.stopAnimating()
            self.isUserInteractionEnabled = true
            return cell
        })
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        
        updateSnapshot()
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        bringSubviewToFront(indicatorView)
        indicatorView.startAnimating()
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 5
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func updateSnapshot(reloading archive: [Archive] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(archive, toSection: .main)
        if !archive.isEmpty {
            snapshot.reloadItems(archive)
        }
        if snapshot.itemIdentifiers.isEmpty {
            collectionView.setEmptyView()
        } else {
            collectionView.restore()
        }
        dataSource.apply(snapshot)
    }
}

extension ArchiveListView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return archiveList.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCell.identifier, for: indexPath) as! ArchiveCell
//        let archive = archiveList[indexPath.item]
//        cell.configure(archive: archive)
//        indicatorView.stopAnimating()
//        self.isUserInteractionEnabled = true
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetailView(indexPath: indexPath)
    }
}
