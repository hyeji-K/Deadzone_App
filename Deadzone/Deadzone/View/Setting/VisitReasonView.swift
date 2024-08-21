//
//  VisitReasonView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/13.
//

import UIKit

final class VisitReasonView: UIView {
    private let feelingList: [String] = ["부럽고 샘나는", "지치는", "우울한", "공허한", "화가 나는", "소외감이 드는"]
    var feeling: String?
    weak var dataDelegate: DataSendDelegate?
    
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
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: "지금은 어떤 감정으로\n데드존에 방문하게 되셨나요?", lineHeight: 20)
        label.textColor = DZColor.black
        label.font = DZFont.text16
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
        addSubview(containerView)
        addSubview(handlebarView)
        addSubview(titleLabel)
        addSubview(feelingTableView)
        addSubview(nextButton)
        
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
            make.top.equalToSuperview().offset(52)
            make.centerX.equalToSuperview()
        }
        feelingTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.left.right.equalToSuperview().inset(42)
            make.height.equalTo(400)
        }
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(66)
        }
    }
}

extension VisitReasonView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeelingCell.identifier, for: indexPath) as! FeelingCell
        cell.configure(title: feelingList[indexPath.row])
        if self.feelingList[indexPath.row] == self.feeling {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataDelegate?.sendData(data: feelingList[indexPath.row])
    }
}

