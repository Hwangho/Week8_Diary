//
//  BaseView.swift
//  SeSAC2DiaryRealm
//
//  Created by 황호 on 2022/08/21.
//

import UIKit


class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupAttributes() {
        self.backgroundColor = Constants.BaseColor.background
    }
    
    func setupLayout() {}
    
    func setupBinding() {}
//
}

