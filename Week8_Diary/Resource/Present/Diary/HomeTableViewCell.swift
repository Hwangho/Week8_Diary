//
//  HomeTableViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by 황호 on 2022/08/23.
//

import UIKit

import SnapKit


class HomeTableViewCell: BaseTableViewCell {
    
    let favoritButton = UIButton()
    
    let todoCheckButton = UIButton()
    
    let titleLable = UILabel()
    
    let lineView = UIView()
    
    var changeFavorite: (() -> ())?
    
    var checkBoxClicked: (() -> ())?
    
    
    
    
    override func setAttribute() {
        lineView.backgroundColor = .darkGray
        
        favoritButton.addTarget(self, action: #selector(tapStarButton), for: .touchUpInside)
        favoritButton.tintColor = .orange
        
        todoCheckButton.addTarget(self, action: #selector(tapCheckBoxButton), for: .touchUpInside)
        todoCheckButton.tintColor = .darkGray
    }
    
    override func setLayout() {
        titleLable.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(titleLable.snp.width)
            make.height.equalTo(1)
        }
        
        [favoritButton, todoCheckButton, titleLable].forEach{ contentView.addSubview($0) }
        
        todoCheckButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
        }
        
        favoritButton.snp.makeConstraints { make in
            make.centerY.equalTo(todoCheckButton.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
        }
        
        titleLable.snp.makeConstraints { make in
            make.centerY.equalTo(todoCheckButton.snp.centerY)
            make.leading.equalTo(todoCheckButton.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualTo(favoritButton.snp.leading).inset(-30)
        }
    }
    

    func setData(data: Diary) {
        titleLable.text = data.content
//        titleLable.attributedText = titleLable.text?.strikeThrough(makeLine: data.checkBox)
        titleLable.textColor = data.checkBox ? .lightGray : .black
        lineView.isHidden = !data.checkBox
        
        
        favoritButton.setImage(UIImage(systemName: changeImage(isclicked: data.favorite, clickImage: "star.fill", unclickImage: "star")), for: .normal)
        favoritButton.tintColor = data.checkBox ? .orange.withAlphaComponent(0.3) : .orange
            
        
        todoCheckButton.setImage(UIImage(systemName: changeImage(isclicked: data.checkBox, clickImage: "checkmark.square.fill", unclickImage: "checkmark.square")), for: .normal)
    }
    
    func changeImage(isclicked: Bool, clickImage: String, unclickImage: String) -> String {
        return isclicked ? clickImage : unclickImage
    }
    
    @objc
    func tapStarButton() {
        changeFavorite?()
    }
    
    @objc
    func tapCheckBoxButton() {
        checkBoxClicked?()
    }
    
    
}
