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
    
    func contain(in rect: CGRect, inset: CGFloat = 10) -> CGPoint{
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
