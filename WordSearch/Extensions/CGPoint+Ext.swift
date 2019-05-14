//
//  CGPoint+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-12.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit
extension CGPoint {
    func distance(from secondPoint: CGPoint ) -> Double {
        return Double(pow((secondPoint.x - self.x), 2) + pow((secondPoint.y - self.y), 2))
    }
}
