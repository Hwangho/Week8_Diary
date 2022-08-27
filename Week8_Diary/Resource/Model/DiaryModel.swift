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




extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}
