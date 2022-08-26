//
//  BaseTableViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by 황호 on 2022/08/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setLayout()
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {}
    
    func setAttribute() {
        contentView.backgroundColor = Constants.BaseColor.background
    }
    
    func configure() {}
    
    func setConstraints() {}
}
