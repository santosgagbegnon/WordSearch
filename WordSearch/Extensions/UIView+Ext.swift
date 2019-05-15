//
//  UICollectionViewCell+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-12.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit
extension UIView {
    /// Calculates the four corner points of the cell in the coordinate system of its superview
    var cornerPoints : [CGPoint]{
        let topLeft = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        let topRight = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY)
        let bottomRight = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
    
    /// Calculates the four mid points of the cell in the coordinate system of its superview
    var midPoints : [CGPoint] {
        let topMid = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        let rightMid = CGPoint(x: self.frame.maxX, y: self.frame.midY)
        let bottomMid = CGPoint(x: self.frame.midX, y: self.frame.minY)
        let leftMid = CGPoint(x: self.frame.minX, y: self.frame.midY)
        return [topMid, rightMid, bottomMid, leftMid]
    }
    
    
    /// Adds a gradient to the view
    ///
    /// - Parameters:
    ///   - startColour: first colour of the gradient
    ///   - endColour: second colour of the gradient
    ///   - locations: locations of the gradient path
    func addGradientBackground(startColour: UIColor, endColour: UIColor, locations: [NSNumber] = [0,0.95]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColour.cgColor,endColour.cgColor]
        gradientLayer.locations = locations
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.setNeedsDisplay()
    }
    
    
    /// Adds a shadow to the view
    ///
    /// - Parameters:
    ///   - colour: colour of the shadow
    ///   - offset: offset of the shadow
    ///   - radius: radius of the shadow
    ///   - opacity: opacity of the shadow
    func addShadow(colour: UIColor = UIColor.black,offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 3, opacity: Float = 0.5){
        self.layer.shadowColor = colour.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
}
