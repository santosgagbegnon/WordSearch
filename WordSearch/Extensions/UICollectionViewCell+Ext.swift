//
//  UICollectionViewCell+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-12.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit
extension UICollectionViewCell {
    
    /// Calculates the four corner points of the cell in the coordinate system of its superview
    var cornerPoints : [CGPoint]{
        let topLeft = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        let topRight = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY)
        let bottomRight = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
    
    var midPoints : [CGPoint] {
        let topMid = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        let rightMid = CGPoint(x: self.frame.maxX, y: self.frame.midY)
        let bottomMid = CGPoint(x: self.frame.midX, y: self.frame.minY)
        let leftMid = CGPoint(x: self.frame.minX, y: self.frame.midY)
        return [topMid, rightMid, bottomMid, leftMid]
    }
}
