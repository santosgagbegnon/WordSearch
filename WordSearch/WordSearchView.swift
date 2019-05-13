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
    private var endingPoint : CGPoint!
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
        endingPoint = touch.location(in: self)
        let startX = startingPoint.x
        let startY = startingPoint.y
        let endX = endingPoint.x
        let endY = endingPoint.y

        let opposite = endY - startY
        let adjacent = endX - startX
        let originalAngle = Double(atan2(opposite, adjacent))
        
        let roundedAngle = originalAngle.round() * Double.pi/180
        
        //Checks to see if the rounded angle is 90 degrees
        if (abs(roundedAngle * 180/Double.pi) == 90) {
            endingPoint = CGPoint(x: startingPoint.x, y: touch.location(in: self).y)
        }
        else{
            let newY = snapY(theta: roundedAngle, x1: Double(startX), x2: Double(endX), y1: Double(startY))
            endingPoint = CGPoint(x: endingPoint.x, y: CGFloat(newY))
        }
        
        //Get the indexPath of the cell touched at the location of the tap
        guard let indexPath = self.indexPathForItem(at: endingPoint),
            let _ = self.cellForItem(at: indexPath) as? LetterCell else {
                return
        }
        
        //Adds the cell's indexPath to the array of hihglighted index paths
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        let points = calculateLinePath(firstIndexPath: highlightedIndexPaths[0], secondIndexPath: highlightedIndexPaths[highlightedIndexPaths.count-1])
       
        startingPoint = points.startingPoint
        if(highlightedIndexPaths.count == 1){
            endingPoint = points.endingPoint

        }
        
        //Create highlighting line path
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endingPoint)
    
        //Create layer for highlighting path
        let drawLayer = CAShapeLayer()
        drawLayer.name = "DrawLayer"
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.lineWidth = 20
        drawLayer.path = drawPath.cgPath
        drawLayer.lineCap = .round
        drawLayer.lineJoin = .round
        
        //Add and update view
        self.layer.addSublayer(drawLayer)
        self.setNeedsLayout()
        
        for indexPath in highlightedIndexPaths {
            if let cell = self.cellForItem(at: indexPath) as? LetterCell{
                if (!drawPath.contains(cell.center)){
                    if let index = highlightedIndexPaths.firstIndex(of: indexPath), index != 0{
                        highlightedIndexPaths.remove(at: index)
                    }
                }
               
            }
        }
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
    
    
    /// Calculates the starting and ending points of the highlight path
    ///
    /// - Parameters:
    ///   - firstIndexPath: The index path of the first cell to highlight
    ///   - secondIndexPath: The index path of the last cell to highlight
    /// - Returns: Starting and ending points for the highlighting path
    private func calculateLinePath(firstIndexPath : IndexPath, secondIndexPath: IndexPath) -> (startingPoint: CGPoint, endingPoint: CGPoint){
        var linePath = (startingPoint: CGPoint(x: 0, y: 0), endingPoint: CGPoint(x: 0, y: 0))
       
        guard let firstCell = self.cellForItem(at: firstIndexPath),
            let secondCell = self.cellForItem(at: secondIndexPath) else{
                return linePath
        }
        //Default: assume line is diagonal
        var firstPoints = firstCell.cornerPoints
        var secondPoints = secondCell.cornerPoints
        
        if (firstIndexPath.row == secondIndexPath.row || firstIndexPath.section == secondIndexPath.section){
            //Not a diagonal line, change points
            firstPoints = firstCell.midPoints
            secondPoints = secondCell.midPoints
        }
       
        var furthestDistance : Double = 0
       
        for point1 in firstPoints {
            for point2 in secondPoints {
                let distance = point1.distance(from: point2)
                if (distance >= furthestDistance){
                    furthestDistance = distance
                    linePath.startingPoint = point1
                    linePath.endingPoint = point2
                }
            }
        }
        return linePath
    }
}
