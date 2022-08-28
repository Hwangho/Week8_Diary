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
    
    let repository = DiaryRepository()
    
    var filterType: DiaryRepository.Filter = .all {
        didSet {
            data = repository.featchData(filtertype: filterType)
        }
    }
    
    var data: Results<Diary>! {
        didSet {
            tableview.reloadData()
        }
    }
    
    
    // Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = repository.featchData(filtertype: filterType)
    }
    
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
        data = repository.featchData(filtertype: filterType)
    }
    
    override func setupBinding() {
        addTextView.addText = { [weak self] data in
            self?.repository.addData(data: data)
            self?.data = self?.repository.featchData(filtertype: self!.filterType)
        }
    }
    
    
    // Action
    @objc
    func deleteTodo() {
        deletShowAlert()
    }
    
    @objc
    func backupTodo() {
        let vc = BackUpViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    // Custom func
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        
        let filter = UIBarButtonItem(title: "필터", style: .plain, target: self, action: nil)
        
        let all = UIAction(title: DiaryRepository.Filter.all.rawValue , image: nil, handler: { [weak self] _ in
            self?.filterType = .all
        })
        let favorite = UIAction(title: DiaryRepository.Filter.favorite.rawValue , image: UIImage(systemName: "star.fill"), handler: { [weak self] _ in
            self?.filterType = .favorite
        })
        let checkBox = UIAction(title: DiaryRepository.Filter.check.rawValue , image: UIImage(systemName: "checkmark.square.fill"), handler: { [weak self] _ in
            self?.filterType = .check
        })
        filter.menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [all, favorite, checkBox])
        navigationItem.leftBarButtonItems = [filter]
        
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTodo))
        let bakcUp = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupTodo))
        navigationItem.rightBarButtonItems = [delete, bakcUp]
    }
    
    func deletShowAlert() {
        let data = self.data.filter { $0.checkBox == true }
        
        if data.isEmpty {
            showAlertMessage(title: "제거할 리스트를 선택해주세요")
        } else {
            let alert = UIAlertController(title: nil, message: "해당 리스트를 제거하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "예", style: .default) {[weak self] _ in
                self?.repository.deleteDatas(data: data)
                self?.data = self?.repository.featchData(filtertype: self!.filterType)
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
            if let data = self?.data[indexPath.row] {
                self?.repository.updatecheckBoxData(task: data)
                self?.data = self?.repository.featchData(filtertype: self!.filterType)
            }
        }
        
        cell.changeFavorite = { [weak self] in
            if let data = self?.data[indexPath.row] {
                self?.repository.updateFavoriteData(task: data)
                self?.data = self?.repository.featchData(filtertype: self!.filterType)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] action, view, handler in
            if let data = self?.data[indexPath.row] {
                self?.repository.deleData(data: data)
                self?.data = self?.repository.featchData(filtertype: self!.filterType)
            }
        }
        
        delete.backgroundColor = .red
        let trailingButton = UISwipeActionsConfiguration(actions: [delete])
        
        return trailingButton
    }
    
}
