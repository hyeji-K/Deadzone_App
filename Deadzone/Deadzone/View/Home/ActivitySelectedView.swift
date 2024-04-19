//
//  ActivitySelectedView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

final class ActivitySelectedView: UIView {
    
    private let activityList: [String] = ["음악", "카페", "명상", "독서", "음주", "패션"]
    private let activityImageList: [UIImage] = [DZImage.music01, DZImage.cafe02, DZImage.meditation03, DZImage.reading04, DZImage.drinking05, DZImage.fashion06]
    var activitys: [String] = []
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.backgroundColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private let handlebarView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.grayColor200
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그대의 방을 어떤 활동으로 채워볼까요?"
        label.font = DZFont.text14
        label.textColor = DZColor.black
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "활동은 2개까지 선택 가능해요."
        label.font = DZFont.subText12
        label.textColor = DZColor.errorColor
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return collectionView
    }()
    
    let doneButton: UIButton = {
        let button = MainButton()
        button.setTitle("선택 완료", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    let newActivityButton: UIButton = {
        let button = UIButton()
        button.setTitle("이중에 없어요", for: .normal)
        button.setTitleColor(DZColor.subGrayColor100, for: .normal)
        button.titleLabel?.font = DZFont.subText10
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.subGrayColor100
        return view
    }()
    
    private lazy var newActivityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newActivityButton, underlineView])
        stackView.axis = .vertical
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        addSubview(handlebarView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(collectionView)
        addSubview(doneButton)
        addSubview(newActivityStackView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        handlebarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(6)
            make.width.equalTo(60)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(57)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.identifier)
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(47)
            make.left.right.equalToSuperview().inset(16)
        }
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        newActivityStackView.snp.makeConstraints { make in
            make.top.equalTo(doneButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ActivitySelectedView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.identifier, for: indexPath) as! ActivityCell
        cell.configure(image: activityImageList[indexPath.item], title: activityList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.activitys.append(activityList[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        subTitleLabel.isHidden = false
        doneButton.isEnabled = true
        return collectionView.indexPathsForSelectedItems?.count ?? 0 <= 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems?.count == 0 {
            subTitleLabel.isHidden = true
            doneButton.isEnabled = false
        }
        if let index = activitys.firstIndex(of: activityList[indexPath.item]) {
            self.activitys.remove(at: index)
        }
    }
}
