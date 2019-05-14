//
//  WordSearchViewDelegate.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
protocol WordSearchViewDelegate {
    func didHighlightWord(wordSearchView : WordSearchView, letters : [String])
}

extension WordSearchViewDelegate {
    func didHighlightWord(wordSearchView : WordSearchView, letters : [String] ) {}
}
