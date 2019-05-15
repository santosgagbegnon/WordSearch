//
//  CGPoint+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-12.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit
extension CGPoint {
    
    /// Calcultes the euclidean distance betwene two points
    ///
    /// - Parameter secondPoint: second point to calculate distance of
    /// - Returns: the distance between the points
    func distance(from secondPoint: CGPoint ) -> Double {
        return Double(pow((secondPoint.x - self.x), 2) + pow((secondPoint.y - self.y), 2))
    }
    
    
    /// Creates point within bounds of the rectangle
    ///
    /// - Parameters:
    ///   - rect: rectangle bounds
    ///   - inset: inset of the bounds
    /// - Returns: new point within the points of the rectangle
    func contain(in rect: CGRect, inset: CGFloat = 16) -> CGPoint{
        var newPoint = self
        if(self.x <= inset){
            newPoint.x = inset
        }
        else if(self.x >= rect.width-inset){
            newPoint.x = rect.width-inset

        }
        if(self.y <= inset){
            newPoint.y = inset
        }
        if(self.y >= rect.height-inset){
            newPoint.y = rect.height-inset
        }
        return newPoint
    }
}
