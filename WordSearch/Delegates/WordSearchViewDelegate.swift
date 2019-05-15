//
//  WordSearchViewDelegate.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
protocol WordSearchViewDelegate {
    
    /// Tells the WordSearchView if the word that is currently being highlighted should remove highlighted past the touch events
    ///
    /// - Parameters:
    ///   - wordSearchView: the sender
    ///   - word: word being highlighted
    /// - Returns: true if the word should remain highlighted, otherwise false
    func shouldRemainHightlighed(wordSearchView: WordSearchView, word:String) -> Bool
}

