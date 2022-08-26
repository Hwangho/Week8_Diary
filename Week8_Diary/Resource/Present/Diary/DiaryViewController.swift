//
//  DiaryViewController.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/23.
//

import UIKit

import SnapKit
import RealmSwift

class DiaryViewController: BaseViewController {
    
    // variable
    let tableview = UITableView()

    let addTextView = DiaryAddTextView()
    
    let localRealm = try! Realm()
    
    var filterType: Filter = .all {
        didSet {
            featchData(filtertype: filterType)
        }
    }
    
    var data: Results<Diary>! {
        didSet {
            tableview.reloadData()
        }
    }
    
    
    // Life Cycle
    override func setupAttributes() {
        super.setupAttributes()
        
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 50
        tableview.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        
        setNavigationBar()
    }
    
    override func setupLayout() {
        [addTextView, tableview].forEach{ view.addSubview($0) }
        
        addTextView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableview.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(addTextView.snp.bottom)
        }
        
    }
    
    override func setData() {
        featchData(filtertype: filterType)
    }
    
    override func setupBinding() {
        addTextView.addText = { [weak self] data in
            do {
                try self?.localRealm.write({
                    self?.localRealm.add(data)
                    self?.featchData(filtertype: self!.filterType)
                })
            } catch {
                self?.showAlertMessage(title: "error 났음")
            }
        }
    }
    

    // Custom func
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        
        let filter = UIBarButtonItem(title: "필터", style: .plain, target: self, action: nil)
    
        let all = UIAction(title: Filter.all.rawValue , image: nil, handler: { [weak self] _ in
            self?.filterType = .all
        })
        let favorite = UIAction(title: Filter.favorite.rawValue , image: UIImage(systemName: "star.fill"), handler: { [weak self] _ in
            self?.filterType = .favorite
        })
        let checkBox = UIAction(title: Filter.check.rawValue , image: UIImage(systemName: "checkmark.square.fill"), handler: { [weak self] _ in
            self?.filterType = .check
        })
        filter.menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [all, favorite, checkBox])
        navigationItem.leftBarButtonItems = [filter]
        
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTodo))
        let bakcUp = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupTodo))
        navigationItem.rightBarButtonItems = [delete, bakcUp]
    }
    
    
    @objc
    func deleteTodo() {
        deletShowAlert()
    }
    
    @objc
    func backupTodo() {
        let vc = BackUpViewController()
        self.present(vc, animated: true)
    }
    
    func deletShowAlert() {
        let data = self.data.filter { $0.checkBox == true }
        
        if data.isEmpty {
            showAlertMessage(title: "제거할 리스트를 선택해주세요")
        } else {
            let alert = UIAlertController(title: nil, message: "해당 리스트를 제거하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "예", style: .default) { _ in
                do {
                    try self.localRealm.write({
                        self.localRealm.delete(data)
                        self.featchData(filtertype: self.filterType)
                    })
                }
                catch {
                    print(error)
                }
            }
            let cancle = UIAlertAction(title: "아니요", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancle)
            present(alert, animated: true)
        }
    }
    
}


// - MARK: UITableViewDataSource, UITableViewDelegate Extension

extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as? HomeTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setData(data: data[indexPath.row])
        cell.checkBoxClicked = { [weak self] in
            do {
                try self?.localRealm.write({
                    self?.data[indexPath.row].checkBox = !(self?.data[indexPath.row].checkBox)!
                    self?.featchData(filtertype: self!.filterType)
                })
            } catch {
                self?.showAlertMessage(title: "checkBox 변경 안됨!")
            }
        }
        cell.changeFavorite = { [weak self] in
            do {
                try self?.localRealm.write({
                    self?.data[indexPath.row].favorite = !(self?.data[indexPath.row].favorite)!
                    self?.featchData(filtertype: self!.filterType)
                })
            } catch {
                self?.showAlertMessage(title: "Favorite 변경 안됨!")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [self] action, view, handler in
            do {
                try localRealm.write({
                    localRealm.delete(data[indexPath.row])
                    featchData(filtertype: filterType)
                    
                })
            } catch {
                print("delete 관련 error")
            }
        }
        
        delete.backgroundColor = .red
        
         let trailingButton = UISwipeActionsConfiguration(actions: [delete])
        
        return trailingButton
    }
    
}


// - MARK: filter

extension DiaryViewController {
    
    enum Filter: String, CaseIterable {
        case all = "전체"
        case favorite = "즐겨찾기"
        case check = "선택"
    }
    
    func featchData(filtertype type: Filter) {
        switch type {
        case .all:
            data = localRealm.objects(Diary.self).sorted(byKeyPath: "content", ascending: true).sorted(byKeyPath: "favorite", ascending: false).sorted(byKeyPath: "checkBox" , ascending: true)
        case .favorite:
            data = localRealm.objects(Diary.self).where({ $0.favorite == true })
        case .check:
            data = localRealm.objects(Diary.self).where({ $0.checkBox == true })
        }
    }
    
}
