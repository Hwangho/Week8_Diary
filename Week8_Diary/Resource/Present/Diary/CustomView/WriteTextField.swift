//
//  WriteTextField.swift
//  SeSAC2DiaryRealm
//
//  Created by 황호 on 2022/08/21.
//

import UIKit

class WriteTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        backgroundColor = Constants.BaseColor.background
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = Constants.Desgin.cornerRadius
        layer.borderWidth = Constants.Desgin.borderWidth
        layer.borderColor = Constants.BaseColor.border
        textColor = Constants.BaseColor.text
    }

    func setPlacehoder(text: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [.foregroundColor: color])
    }
}
