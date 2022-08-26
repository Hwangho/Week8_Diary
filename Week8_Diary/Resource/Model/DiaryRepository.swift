//
//  DiaryRepository.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/26.
//

import RealmSwift
import UIKit



class DiaryRepository {
    
    enum Filter: String, CaseIterable {
        case all = "전체"
        case favorite = "즐겨찾기"
        case check = "선택"
    }
    
    let localRealm = try! Realm()
    
    var filterType: Filter = .all
    
    
    func featchData(filtertype type: Filter) -> Results<Diary> {
        switch type {
        case .all:
            return localRealm.objects(Diary.self).sorted(byKeyPath: "content", ascending: true).sorted(byKeyPath: "favorite", ascending: false).sorted(byKeyPath: "checkBox" , ascending: true)
        case .favorite:
            return localRealm.objects(Diary.self).where({ $0.favorite == true })
        case .check:
            return localRealm.objects(Diary.self).where({ $0.checkBox == true })
        }
    }
    
    func addData(data: Diary) {
        do {
           try localRealm.write({
                localRealm.add(data)
            })
        } catch {
            print("메모를 추가하는데 error가 생겼습니다.")
        }
    }
    
    func deleteDatas<T: Sequence>(data: T) where T.Iterator.Element: ObjectBase  {
        do {
           try localRealm.write({
                localRealm.delete(data)
            })
        } catch {
            print("메모를 제거하는데 error가 생겼습니다.")
        }
    }
    
    func deleData(data: ObjectBase) {
        do {
           try localRealm.write({
                localRealm.delete(data)
            })
        } catch {
            print("메모를 제거하는데 error가 생겼습니다.")
        }
    }
    
    func updatecheckBoxData(task: Diary) {
        do {
           try localRealm.write({
               task.checkBox = !task.checkBox
            })
        } catch {
            print("checkBox 변경 안됨")
        }
    }
    
    func updateFavoriteData(task: Diary) {
        do {
           try localRealm.write({
               task.favorite = !task.favorite
            })
        } catch {
            print("checkBox 변경 안됨")
        }
    }
}
