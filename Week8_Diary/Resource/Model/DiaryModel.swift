//
//  DiaryModel.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/25.
//

import UIKit
import RealmSwift

class Diary: Object {
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var content: String
    @Persisted var favorite: Bool
    @Persisted var checkBox: Bool
    @Persisted var dateRegistered: Date
    
    convenience init(content: String, favorite: Bool = false, checkBox: Bool = false, dateRegistered: Date = Date() ) {
        self.init()
        self.content = content
        self.favorite = favorite
        self.checkBox = checkBox
        self.dateRegistered = dateRegistered
    }
    
    func serialize() -> [String : Any] {
        return [
            "id" : 1,
            "content" : self.content,
            "favorite" : self.favorite,
            "checkBox" : self.checkBox,
            "dateRegistered" : dateChangeStirng(self.dateRegistered)  // Date()는 json으로 변경 불가!!!! String으로 바꿔줘야 한다!!
       ]
    }
    
    private func dateChangeStirng(_ date: Date) -> String {
        return formatter.string(from: date)
    }
    
    private func stringChangeDate(_ string: String) -> Date {
        return formatter.date(from: string)!
    }
    

}


extension Date {
     func dateChangeStirng() -> String {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        return formatter.string(from: self)
    }
}

extension String {
     func stringChangeDate() -> Date {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        return formatter.date(from: self)!
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
