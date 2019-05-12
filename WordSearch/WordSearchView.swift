//
//  WordSearchView.swift
//  WordSearch
//
//  Created by Santos on 2019-05-05.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class WordSearchView: UICollectionView, UICollectionViewDelegate {
    private var highlightedIndexPaths = [IndexPath]()
    private var startingPoint : CGPoint!
    private var endPoint : CGPoint!
    private var drawPath : UIBezierPath!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        startingPoint = touch.location(in: self)
        guard let indexPath = self.indexPathForItem(at: startingPoint),
            let targetCell = self.cellForItem(at: indexPath) as? LetterCell else {
            return
        }
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        startingPoint = targetCell.center
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        clearCanvas()
        endPoint = touch.location(in: self)
        let startX = startingPoint.x
        let startY = startingPoint.y
        let endX = endPoint.x
        let endY = endPoint.y

        let opposite = endY - startY
        let adjacent = endX - startX
        let originalAngle = Double(atan2(opposite, adjacent))
        
        let roundedAngle = originalAngle.round() * Double.pi/180
        
        //Checks to see if the rounded angle is 90 degrees
        if (abs(roundedAngle * 180/Double.pi) == 90) {
            endPoint = CGPoint(x: startingPoint.x, y: touch.location(in: self).y)
        }
        else{
            let newY = snapY(theta: roundedAngle, x1: Double(startX), x2: Double(endX), y1: Double(startY))
            endPoint = CGPoint(x: endPoint.x, y: CGFloat(newY))
        }
        
        //Get the indexPath of the cell touched at the location of the tap
        guard let indexPath = self.indexPathForItem(at: endPoint),
            let _ = self.cellForItem(at: indexPath) as? LetterCell else {
                return
        }
        
        //Adds the cell's indexPath to the array of hihglighted index paths
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        
        //Create highlighting line path
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endPoint)
        drawPath.lineCapStyle = .round
        drawPath.lineJoinStyle = .round
        drawPath.close()
        
        //Create layer for highlighting path
        let drawLayer = CAShapeLayer()
        drawLayer.name = "DrawLayer"
        drawLayer.fillColor = UIColor.red.cgColor
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.lineWidth = 20
        drawLayer.path = drawPath.cgPath
        
        //Add and update view
        self.layer.addSublayer(drawLayer)
        self.setNeedsLayout()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var word = ""
        for indexPath in highlightedIndexPaths {
            if let cell = self.cellForItem(at: indexPath) as? LetterCell {
                word += cell.letterLabel.text ?? ""
            }
        }
        print("Final word: \(word)")
        highlightedIndexPaths = []
        clearCanvas()
    }
    
    /// Clears the highlighting path on the word search
    private func clearCanvas(){
        if(drawPath == nil){return}
        drawPath.removeAllPoints()
        guard let layers = self.layer.sublayers else{
            return
        }
        var newLayers = [CALayer]()
        for (_,layer) in layers.enumerated() {
            if (layer.name != "DrawLayer"){
                newLayers.append(layer)
            }
        }
        self.layer.sublayers = newLayers
        self.setNeedsLayout()
    }
    
    /// Calculates the approriate Y using the Tan trig function
    ///
    /// - Parameters:
    ///   - theta: Angle
    ///   - x1: X value of point 1
    ///   - x2: X value of point 2
    ///   - y1: Y value of point 1
    /// - Returns: Y value of point 2
    private func snapY(theta: Double, x1: Double, x2 :Double, y1: Double) -> Double{
        return tan(theta)*(x2-x1) + y1
    }
}
