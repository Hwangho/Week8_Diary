//
//  DiaryAddTextView.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/25.
//

import UIKit

import RealmSwift


class DiaryAddTextView: BaseView {
    
    // Variable
    let backView = UIView()
    
    let stackView = UIStackView()
    
    let textField = UITextField()
    
    let addButton = UIButton()
    
    var addText: ((Diary) -> ())?
    
    
    // Life Cycle
    override func setupLayout() {
        
        [textField, addButton].forEach { stackView.addArrangedSubview($0) }
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(stackView.snp.height)
        }
        
        backView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(backView)
            make.leading.equalTo(backView).inset(20)
            make.trailing.equalTo(backView).inset(5)
            make.height.equalTo(40)
        }
        
        addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    override func setupAttributes() {
        stackView.axis = .horizontal
        
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.clipsToBounds = true
        
        addButton.isHidden = true
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.placeholder = "리스트를 추가하세요."
        
    }
    
    override func setupBinding() {
        
    }
    
    @objc
    func textFieldEditingChanged(_ sender: Any) {
        guard let text = self.textField.text else { return }
        addButton.isHidden = text.isEmpty ? true : false
    }
    
    @objc
    func tapPlusButton() {
        guard let text = textField.text else { return }
        let diary = Diary(content: text)
        addText?(diary)
        textField.text = ""
        addButton.isHidden = true
        textField.resignFirstResponder()
    }
}

