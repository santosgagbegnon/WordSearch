//
//  ShadowView.swift
//  WordSearch
//
//  Created by Santos on 2019-05-15.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addShadow()
        self.backgroundColor = UIColor.white
    }
}
