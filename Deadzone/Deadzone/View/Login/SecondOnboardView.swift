//
//  SecondOnboardView.swift
//  Deadzone
//
//  Created by heyji on 2024/04/04.
//

import UIKit

protocol DataSendDelegate: AnyObject {
    func sendData(data: String?)
}

final class SecondOnboardView: UIView {
    
    private let feelingList: [String] = ["부럽고 샘나는", "지치는", "우울한", "공허한", "화가 나는", "소외감이 드는"]
    weak var dataDelegate: DataSendDelegate?

    private let pageControlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DZImage.pageControl2
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "그대, 어떤 감정으로 인해\n데드존을 찾아오게 되셨나요?", lineHeight: 22)
        label.textColor = DZColor.black
        label.font = DZFont.heading
        label.textAlignment = .center
        return label
    }()
    
    lazy var feelingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeelingCell.self, forCellReuseIdentifier: FeelingCell.identifier)
        return tableView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(DZImage.nextButton, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(pageControlImageView)
        addSubview(titleLabel)
        addSubview(feelingTableView)
        addSubview(nextButton)
        
        pageControlImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControlImageView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        feelingTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.left.right.equalToSuperview().inset(42)
            make.height.equalTo(400)
        }
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}

extension SecondOnboardView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeelingCell.identifier, for: indexPath) as! FeelingCell
        cell.configure(title: feelingList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataDelegate?.sendData(data: feelingList[indexPath.row])
    }
}
