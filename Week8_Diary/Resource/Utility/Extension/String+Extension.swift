//
//  String+Extension.swift
//  Week8_Diary
//
//  Created by 송황호 on 2022/08/25.
//

import UIKit


extension String {
    func strikeThrough(makeLine: Bool) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        
        if makeLine {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            return attributeString
        } else {
            
            return attributeString
        }
    }
}
