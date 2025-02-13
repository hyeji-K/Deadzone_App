//
//  ActivitySelectedView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/17.
//

import UIKit

protocol ActivitySelectionDelegate: AnyObject {
    var maximumSelectionCount: Int { get }
    
    func numberOfSelectedItems(in collectionView: UICollectionView) -> Int
    func activityCollectionView(_ collectionView: ActivitySelectedView, didSelectActivity activity: String)
    func activityCollectionView(_ collectionView: ActivitySelectedView, didDeselectActivity activity: String)
    func configureSelection(forActivity activity: String,
                            in collectionView: UICollectionView,
                            at indexPath: IndexPath)
}

final class ActivitySelectedView: UIView {
    
    private let activityList: [ActivityList] = ActivityList.list
    private let bottomSheetHeight: CGFloat = 364
    private let animationDuration: TimeInterval = 0.3
    
    weak var selectionDelegate: ActivitySelectionDelegate?
    
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
    
    let subTitleLabel: UILabel = {
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
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: ActivityCell.identifier)
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
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
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSubTitle() {
        subTitleLabel.isHidden = false
        subTitleLabel.text = "활동을 변경하면, 기존에 선택한 활동은 저장되지 않아요."
    }
    
    private func addSubviews() {
        addSubview(containerView)
        addSubview(handlebarView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(collectionView)
        addSubview(doneButton)
        addSubview(newActivityStackView)
    }
    
    private func setupConstraints() {
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
    
    func showBottomSheet() {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.snp.updateConstraints { make in
                make.height.equalTo(self.bottomSheetHeight)
            }
            self.superview?.layoutIfNeeded()
        }
    }
    
    func dismissBottomSheet(completion: (() -> Void)? = nil) {
        guard let superview = self.superview else { return }
        
        UIView.animate(
            withDuration: animationDuration,
            animations: { [weak self] in
                guard let self = self else { return }
                self.frame.origin = CGPoint(
                    x: superview.frame.origin.x,
                    y: superview.frame.size.height
                )
            },
            completion: { isCompleted in
                if isCompleted {
                    completion?()
                }
            }
        )
    }
}

extension ActivitySelectedView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCell.identifier, for: indexPath) as! ActivityCell
        
        let activity = activityList[indexPath.item]
        cell.configure(image: activity.image, title: activity.title)
        
        // NOTE: 활동 변경 시 선택되어 있는 활동 표시
        selectionDelegate?.configureSelection(forActivity: activity.title,
                                              in: collectionView,
                                              at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let selectionDelegate else { return false }
        let currentSelectedCount = selectionDelegate.numberOfSelectedItems(in: collectionView)
        return currentSelectedCount < selectionDelegate.maximumSelectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activity = activityList[indexPath.item]
        selectionDelegate?.activityCollectionView(self, didSelectActivity: activity.title)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let activity = activityList[indexPath.item]
        selectionDelegate?.activityCollectionView(self, didDeselectActivity: activity.title)
    }
}
