//
//  AlarmView.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

final class AlarmView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.identifier)
        return tableView
    }()
    
    let previousAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("이전 알림도 보기", for: .normal)
        button.setTitleColor(DZColor.subGrayColor100, for: .normal)
        button.titleLabel?.font = DZFont.subText10
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = DZColor.subGrayColor100
        return view
    }()
    
    private lazy var previousAlarmStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousAlarmButton, underlineView])
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
        addSubview(tableView)
        addSubview(previousAlarmStackView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
        }
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        previousAlarmStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(44)
            make.height.equalTo(16)
        }
    }
}

extension AlarmView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmCell.identifier, for: indexPath) as! AlarmCell
        cell.configure(image: DZImage.journal, title: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHaldler in
//            Network.shared.deleteMomentData(momentId: self.momentList[indexPath.row].id)
//            self.momentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHaldler(true)
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: largeConfig)
        deleteAction.backgroundColor = DZColor.red01
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
