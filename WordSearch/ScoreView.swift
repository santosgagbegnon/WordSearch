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
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(displayP3Red: 30/255, green: 110/255, blue: 84/255, alpha: 1).cgColor
    }
}
