//
//  PlacementDirection.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
enum PlacementDirection : CaseIterable {
    case leftRight
    case rightLeft
    case bottomTop
    case topBottom
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
    
    static var allRandomCases : [PlacementDirection] {
        var directions : [PlacementDirection] = [.leftRight, .rightLeft, .bottomTop, .topBottom, .topLeftBottomRight, .topRightBottomLeft, .bottomLeftTopRight, .bottomRightTopLeft ]
        return directions.shuffled()
    }
    
    var direction : (column: Int, row: Int){
        switch self {
        case .leftRight:
            return (1,0)
        case .rightLeft:
            return (-1,0)
        case .bottomTop:
            return (0,-1)
        case .topBottom:
            return (0, 1)
        case .topLeftBottomRight:
            return (1,1)
        case .topRightBottomLeft:
            return (-1,1)
        case .bottomLeftTopRight:
            return (1,-1)
        case .bottomRightTopLeft:
            return (-1,-1)
        }
    }
}
