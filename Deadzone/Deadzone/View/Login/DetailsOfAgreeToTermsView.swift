//
//  DetailsOfAgreeToTermsView.swift
//  Deadzone
//
//  Created by heyji on 2024/08/06.
//

import UIKit

struct TermsData {
    var opened: Bool = false
    var title: String
}

final class DetailsOfAgreeToTermsView: UIView {
    
    private let termsOfUseData: [TermsOfUse] = TermsOfUse.data
    private var termsOfUseList: [TermsData] = [TermsData(title: "제1장 총칙"), TermsData(title: "제2장 서비스 이용계약"), TermsData(title: "제3장 계약 당사자의 의무"), TermsData(title: "제4장 서비스 이용"), TermsData(title: "제5장 계약 해지 및 이용 제한"), TermsData(title: "제6장 면책")]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TermsOfUseCell.self, forCellReuseIdentifier: TermsOfUseCell.identifier)
        tableView.register(ExtendTermsCell.self, forCellReuseIdentifier: ExtendTermsCell.identifier)
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
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}

extension DetailsOfAgreeToTermsView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return termsOfUseList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if termsOfUseList[section].opened == true {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TermsOfUseCell.identifier, for: indexPath) as! TermsOfUseCell
            cell.configure(title: termsOfUseList[indexPath.section].title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExtendTermsCell.identifier, for: indexPath) as! ExtendTermsCell
            cell.configure(title: termsOfUseData[indexPath.section].description)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 55
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermsOfUseCell.identifier, for: indexPath) as! TermsOfUseCell
        if !termsOfUseList[indexPath.section].opened {
            cell.accessoryButton.setImage(DZImage.selectedVector, for: .normal)
        } else {
            cell.accessoryButton.setImage(DZImage.vector, for: .normal)
        }
        if indexPath.row == 0 {
            termsOfUseList[indexPath.section].opened = !termsOfUseList[indexPath.section].opened
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}
