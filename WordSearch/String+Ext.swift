//
//  String+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-11.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
extension String {
    static func randomLetter() -> String{
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String(letters.randomElement()!)
    }
}
