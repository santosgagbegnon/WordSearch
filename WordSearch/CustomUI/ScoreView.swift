//
//  ScoreView.swift
//  WordSearch
//
//  Created by Santos on 2019-05-13.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
import UIKit
class ScoreView : UIView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(named: "WSGreen")?.cgColor ?? UIColor.green.cgColor
    }
}
