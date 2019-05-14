//
//  Character+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
extension Character {
    static func randomLetter() -> Character{
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return letters.randomElement() ?? "A"
    }
}
