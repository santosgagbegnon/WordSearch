//
//  UIStyledView.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func addGradientBackground(startColour: UIColor, endColour: UIColor, locations: [NSNumber] = [0,0.95]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColour.cgColor,endColour.cgColor]
        gradientLayer.locations = locations
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.setNeedsDisplay()
    }
    
    func addShadow(colour: UIColor = UIColor.black,offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 10, opacity: Float = 0.5){
        self.layer.shadowColor = colour.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
