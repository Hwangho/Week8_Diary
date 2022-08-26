//
//  BackUpViewController.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/26.
//

import UIKit

import Zip

class BackUpViewController: BaseViewController {
    
    let backupButton = UIButton()
    
    let restoreButton = UIButton()
    
    let stackView = UIStackView()
    
    let tableview = UITableView()
    
    var data: [URL] = [] {
        didSet {
            tableview.reloadData()
        }
    }
    
    var backupData: ((Int) -> ())?

    
    override func setupAttributes() {
        super.setupAttributes()
        
        backupButton.backgroundColor = .orange
        backupButton.setTitle("백업", for: .normal)
        backupButton.setTitleColor(.black, for: .normal)
        backupButton.layer.cornerRadius = 20
        
        restoreButton.backgroundColor = .green
        restoreButton.setTitle("복구", for: .normal)
        restoreButton.setTitleColor(.black, for: .normal)
        restoreButton.layer.cornerRadius = 20
        
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 100
        tableview.layer.borderWidth = 1
        tableview.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setupLayout() {
        [backupButton, restoreButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        backupButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        [stackView, tableview].forEach {
            view.addSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
        
        backupButton.addTarget(self, action: #selector(tapBackup), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(tapRestore), for: .touchUpInside)
    }
    
    override func setData() {
        data = fetchDocumentZipFile()
    }

    @objc func tapBackup() {
        backupDiary()
    }

    
    @objc func tapRestore() {
        restoreButtonClicked()
    }
    
    
    // MARK: 데이터 백업
    func backupDiary() {
        var urlPaths = [URL]()
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
            return
        }
        print("path ==== \(path)")
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "배업할 파일이 없습니다.")
            return
        }
        urlPaths.append(URL(string:  realmFile.path)!)
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "Diary_\(Date())")
            print("Archive Location: \(zipFilePath)")
            showActivityViewContrioller()
        } catch {
            showAlertMessage(title: "압축에 실패하였습니다.")
        }
        
    }
    
    func showActivityViewContrioller() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
            return
        }
        let backupFileURL = path.appendingPathComponent("Diary_\(Date()).zip")
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        present(vc, animated: true)
    }

    
    // MARK: 복구하기
    func restoreButtonClicked() {

        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    
    // MARK: 압축 파일 가져오기
    func fetchDocumentZipFile() -> [URL] {
        do {
            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
                return []
            }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("docs: \(docs)")

            let zip = docs.filter { $0.pathExtension == "zip" }.map { $0.lastPathComponent }
            print("zip: \(zip)")
            
            return docs
        } catch {
            print("Error")
            return []
        }
    }
}


// - MARK: UIDocumentPickerDelegate

extension BackUpViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
            return
        }
        
        backupData = { row in
            let fileURL = self.data[row]
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료 되었습니다.")
                })
            } catch {
                self.showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}


// - MARK: UITableview DataSource, Delegate

extension BackUpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataName = data.filter { $0.pathExtension == "zip" }.map { $0.lastPathComponent }
        return dataName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let dataName = data.filter { $0.pathExtension == "zip" }.map { $0.lastPathComponent }
        cell.textLabel?.text = dataName[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backupData?(indexPath.row)
    }
}
