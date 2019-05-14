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
            let cell = self.cellForItem(at: indexPath) as? LetterCell else {
                return
        }
        
        //Adds the cell's indexPath to the array of hihglighted index paths
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        let points = calculateLinePath(firstIndexPath: highlightedIndexPaths[0], secondIndexPath: indexPath)
       
        startingPoint = points.startingPoint
        if(highlightedIndexPaths.count == 1){
            endingPoint = points.endingPoint
        }
        //print("Cell: \(cell.letterLabel.text)")
        
        
        let first = highlightedIndexPaths[0]
        guard let firstCell = self.cellForItem(at: first) else{
            print("problem")
                return
        }
        
        let cells = cellsBetween(start: firstCell, end: cell)
        var letters = [String]()
        for cell in cells {
            if let letterCell = cell as? LetterCell,
                let letter = letterCell.letterLabel.text{
                letters.append(letter)
            }
        }
        self.wordSearchViewDelegate?.didHighlightWord(wordSearchView: self, letters: letters)
        
        //Create highlighting line path
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endingPoint)
        drawPath.close()
    
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
        
//        for indexPath in highlightedIndexPaths {
//            if let cell = self.cellForItem(at: indexPath) as? LetterCell{
//                if (!contains(path: drawPath, points: cell.midPoints + cell.cornerPoints)){
//                    if let index = highlightedIndexPaths.firstIndex(of: indexPath), index != 0{
//                        print("removing: \(cell.letterLabel.text)")
//                        highlightedIndexPaths.remove(at: index)
//                    }
//                }
//
//            }
//        }
        
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
    
    private func contains(path : UIBezierPath, points : [CGPoint]) -> Bool {
        for point in points {
            if (path.contains(point)){
                return true
            }
        }
        return false
    }
    
    private func cellsBetween(start startCell: UICollectionViewCell, end endCell: UICollectionViewCell) -> [UICollectionViewCell] {
        var cells = [UICollectionViewCell]()
        cells.append(startCell)

        guard let firstIndexPath = self.indexPath(for: startCell),
            let lastIndexPath = self.indexPath(for: endCell) else {
                return cells
        }
        //Right check
        var currentIndexPath = firstIndexPath
        
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let rightNeighbour = self.rightNeighbour(cell: currentCell),
                let rightIndexPath = self.indexPath(for: rightNeighbour) {
                currentIndexPath = rightIndexPath
                cells.append(rightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        //Left check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let leftNeighbour = self.leftNeighbour(cell: currentCell),
                let leftIndexPath = self.indexPath(for: leftNeighbour) {
                currentIndexPath = leftIndexPath
                cells.append(leftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        //Top check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topNeighbour = self.topNeighbour(cell: currentCell),
                let topIndexPath = self.indexPath(for: topNeighbour) {
                currentIndexPath = topIndexPath
                cells.append(topNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomNeighbour = self.bottomNeighbour(cell: currentCell),
                let bottomIndexPath = self.indexPath(for: bottomNeighbour) {
                currentIndexPath = bottomIndexPath
                cells.append(bottomNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Top right check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topRightNeighbour = self.topRightNeighbour(cell: currentCell),
                let topRightIndexPath = self.indexPath(for: topRightNeighbour) {
                currentIndexPath = topRightIndexPath
                cells.append(topRightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Top left Check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topLeftNeighbour = self.topLeftNeighbour(cell: currentCell),
                let topLeftIndexPath = self.indexPath(for: topLeftNeighbour) {
                currentIndexPath = topLeftIndexPath
                cells.append(topLeftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom Right check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomRightNeighbour = self.bottomRightNeighbour(cell: currentCell),
                let bottomRightIndexPath = self.indexPath(for: bottomRightNeighbour) {
                currentIndexPath = bottomRightIndexPath
                cells.append(bottomRightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom Left check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomLeftNeighbour = self.bottomLeftNeighbour(cell: currentCell),
                let bottomLeftIndexPath = self.indexPath(for: bottomLeftNeighbour) {
                currentIndexPath = bottomLeftIndexPath
                cells.append(bottomLeftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        return cells
    }
    
}
