//
//  SettingView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/12.
//

import UIKit

protocol SettingDelegate {
    func showDetailView(indexPath: IndexPath)
}

final class SettingView: UIView {
    
    private let settingList: [String] = ["개인정보 설정", "알림", "1:1 문의", "이용약관", "체크아웃"]
    var delegate: SettingDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }

}

extension SettingView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.attributedText = NSAttributedString(string: settingList[indexPath.row], attributes: [
            .font: DZFont.text14,
            .foregroundColor: DZColor.black
        ])
        
        content.textProperties.alignment = .natural
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showDetailView(indexPath: indexPath)
    }
}
