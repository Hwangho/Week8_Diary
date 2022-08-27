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
    
    let backButton = UIButton()
    
    var data: [URL] = [] {
        didSet {
            tableview.reloadData()
        }
    }
    
    var backupData: ((Int) -> ())?
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    
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
        
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        
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
        
        [backButton, stackView, tableview].forEach {
            view.addSubview($0)
        }
        backButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(40)
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
    
    override func setupBinding() {
        backupData = { [weak self] row in
            let fileURL = self?.data[row]
            
            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                self?.showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
                return
            }
            
            do {
                try Zip.unzipFile(fileURL!, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self?.showAlertMessage(title: "복구가 완료 되었습니다.")
                })
            } catch {
                self?.showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
        
    }
    
    @objc
    func tapBackButton() {
        dismiss(animated: true)
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
        print("❤️path ==== \(path)❤️")
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "배업할 파일이 없습니다.")
            return
        }
        urlPaths.append(URL(string: realmFile.path)!)
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "Diary_\(formatter.string(from: Date()))")
            print("Archive Location: \(zipFilePath)")
            data = fetchDocumentZipFile()
//            showActivityViewContrioller()     // iphone에 저장할 때
            
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

            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip: \(zip)")
            
            return zip
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
        guard let selecteFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일에 오류가 있습니다.")
            return
        }
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            showAlertMessage(title: "Document 파일 통로를 못찾았습니다.")
            return
        }
        
        // 선택된 파일의 이름과 도큐먼트 통로를 합쳐서 총 file 위치 정보 만들기  -  .../Document + fileName
//        let sandboxFileURL = path.appendingPathComponent(selecteFileURL.lastPathComponent)
//
//        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
//            backupData = { row in
//                let fileURL = self.data[row]
//                do {
//                    try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
//                        print("progress: \(progress)")
//                    }, fileOutputHandler: { unzippedFile in
//                        print("unzippedFile: \(unzippedFile)")
//                        self.showAlertMessage(title: "복구가 완료 되었습니다.")
//                    })
//                } catch {
//                    self.showAlertMessage(title: "압축 해제에 실패했습니다.")
//                }
//            }
//        }
//        else {
//            backupData = { row in
//                let fileURL = self.data[row]
//
//                do {
//                    // 파일 앱의 zip -> 도큐먼트 폴더에 복사
//                    try FileManager.default.copyItem(at: selecteFileURL, to: sandboxFileURL)
//
//                    try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
//                        print("progress: \(progress)")
//                    }, fileOutputHandler: { unzippedFile in
//                        print("unzippedFile: \(unzippedFile)")
//                        self.showAlertMessage(title: "복구가 완료 되었습니다.")
//                    })
//                } catch {
//                    self.showAlertMessage(title: "압축 해제에 실패했습니다.")
//                }
//            }
//
//
//        }
        
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
