//
//  DiaryModel.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/25.
//

import UIKit
import RealmSwift

class Diary: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var content: String
    @Persisted var favorite: Bool
    @Persisted var checkBox: Bool
    @Persisted var dateRegistered: Date
    
    convenience init(content: String, favorite: Bool = false, checkBox: Bool = false) {
        self.init()
        self.content = content
        self.favorite = favorite
        self.checkBox = checkBox
        self.dateRegistered = Date()
    }
}
