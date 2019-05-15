//
//  Double+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-11.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
extension Double {
    /// Rounds double to the nearest value in the set {-180, -135, -90, -45, 0, 45, 90, 135, 180}
    ///
    /// - Returns: rounded degree value
    func round() -> Double{
        //Convert to degrees for readability
        let degree = Double(self * 180 / .pi)
        if (degree >= 157){
            return 180
        }
        else if (degree >= 112){
            return 135
        }
        else if (degree >= 67){
            return 90
        }
        else if (degree >= 22){
            return 45
        }
        else if (degree >= -22){
            return 0
        }
        else if (degree >= -67){
            return -45
        }
        else if (degree >= -112){
            return -90
        }
        else if (degree >= -157){
            return -135
        }
        else{
            return 180
        }
    }
    
}
