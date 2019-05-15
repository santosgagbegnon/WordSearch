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
    var wordSearchViewDelegate : WordSearchViewDelegate? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        if(startingPoint == nil){return}
        guard let touch = touches.first else {
            return
        }
        
        endingPoint = touch.location(in: self)
        
        //Calculate the user's drawing angle
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
        
        //Get the indexPath of the cell touched at the location of the moved touch
        guard let indexPath = self.indexPathForItem(at: endingPoint),
            let currentCell = self.cellForItem(at: indexPath) as? LetterCell else {
                return
        }
        
        //Adds the cell's indexPath to the array of hihglighted index paths
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        let points = calculateLinePath(firstIndexPath: highlightedIndexPaths[0], secondIndexPath: indexPath)
       
        startingPoint = points.startingPoint.contain(in: self.bounds)
        if(highlightedIndexPaths.count == 1){
            endingPoint = points.endingPoint
        }
        
        let firstIndexPath = highlightedIndexPaths[0]
        guard let firstCell = self.cellForItem(at: firstIndexPath) else{
                return
        }
        
        let cells = cellsBetween(start: firstCell, end: currentCell)
        var letters = [String]()
        for cell in cells {
            if let letterCell = cell as? LetterCell,
                let letter = letterCell.letterLabel.text{
                letters.append(letter)
            }
        }
        if (self.wordSearchViewDelegate?.shouldRemainHightlighed(wordSearchView: self, word: letters.joined(separator: "")) == true) {
            startingPoint = nil
            clearCanvas()
            if let endIndexPath = self.indexPath(for: currentCell){
                let path = calculateLinePath(firstIndexPath: firstIndexPath, secondIndexPath: endIndexPath)
                let startingPoint = path.startingPoint.contain(in: self.bounds)
                let endingPoint = path.endingPoint.contain(in: self.bounds)
                drawPath(from: startingPoint, to: endingPoint, layerName: "FoundLayer")
            }
            return
        }
        if(endingPoint != endingPoint.contain(in: self.bounds)){
            return
        }
        clearCanvas()
        drawPath(from: startingPoint, to: endingPoint, layerName: "DrawLayer")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var word = ""
        for indexPath in highlightedIndexPaths {
            if let cell = self.cellForItem(at: indexPath) as? LetterCell {
                word += cell.letterLabel.text ?? ""
            }
        }
        highlightedIndexPaths = []
        clearCanvas()
    }
    
    
    /// Draws a bezier path on the collection view
    ///
    /// - Parameters:
    ///   - startingPoint: the starting point of the path
    ///   - endingPoint: the ending point of the path
    ///   - layerName: name of the path's layer
    private func drawPath(from startingPoint: CGPoint, to endingPoint: CGPoint, layerName : String?){
        var lineWidth = CGFloat(20)
        if let cell = self.cellForItem(at: IndexPath(row: 0, section: 0)) as? LetterCell {
            lineWidth = cell.letterLabel.frame.width + 2

        }
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endingPoint)
        drawPath.close()
        
        //Create layer for highlighting path
        let drawLayer = CAShapeLayer()
        drawLayer.name = layerName
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor(named: "WSGreen")?.cgColor ?? UIColor.green.cgColor
        drawLayer.lineWidth = lineWidth
        drawLayer.path = drawPath.cgPath
        drawLayer.lineCap = .round
        drawLayer.lineJoin = .round
        
        //Add and update view
        self.layer.addSublayer(drawLayer)
        self.setNeedsLayout()
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
       
        guard let firstCell = self.cellForItem(at: firstIndexPath) as? LetterCell,
            let secondCell = self.cellForItem(at: secondIndexPath) as? LetterCell else{
                return linePath
        }
        //Default: assume line is diagonal
        var firstPoints = firstCell.letterLabel.cornerPoints
        var secondPoints = secondCell.letterLabel.cornerPoints
        
        if (firstIndexPath.row == secondIndexPath.row || firstIndexPath.section == secondIndexPath.section){
            //Not a diagonal line, change points
            firstPoints =  firstCell.letterLabel.midPoints
            secondPoints =  secondCell.letterLabel.midPoints
        }
       
        var furthestDistance : Double = 0
       
        for p1 in firstPoints {
            for p2 in secondPoints {
                let point1 = firstCell.convert(p1.contain(in: firstCell.frame), to: self).contain(in: self.frame)
                let point2 = secondCell.convert(p2.contain(in: firstCell.frame), to: self).contain(in: self.frame)

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
