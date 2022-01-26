//
//  File.swift
//  
//
//  Created by 刘万林 on 2021/9/27.
//

import Foundation
import XCTest
@testable import BSKUtils

class TestPinYinClass:XCTestCase {
    func testStringPinyin()throws {
        let pinyin = "中国重庆".pinyin(withFormat: .init(toneType: .toneNumber, vCharType: .uAndColon, caseType: .capitalized), separator: "_") { tons in
            return tons.last ?? ""
        }
        print(pinyin)
    }
    
    func testCharacterPinyin() {
        let c:Character = "尿"
        print(c.pinyin(withFormat: .init(toneType: .toneNumber, vCharType: .uUnicode, caseType: .uppercased)))
    }
}
