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
    var startingPoint : CGPoint!
    var endPoint : CGPoint!
    var drawPath : UIBezierPath!
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
//        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.delegate = self
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
            let targetCell = self.cellForItem(at: indexPath) as? SquareCell else {
            print("nothing found")
            return
        }
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        startingPoint = targetCell.center
        //print("You touched: \(targetCell.letterLabel.text)")
       
        
        print("touches began")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select")
        guard let cell = collectionView.cellForItem(at: indexPath) as? SquareCell else{
            print("not found")
            return
        }
        print("Touched: \(cell.letterLabel.text)")
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
        
        let angle = Double(atan2(opposite, adjacent))
        let aid = (round(radian: angle)) * Double.pi/180
        
        if (abs(aid * 180/Double.pi) == 90) {
            endPoint = CGPoint(x: startingPoint.x, y: touch.location(in: self).y)
        }
        else{
            let newY = snapY(theta: aid, x1: Double(startX), x2: Double(endX), y1: Double(startY))
            endPoint = CGPoint(x: endPoint.x, y: CGFloat(newY))
        }
        
        guard let indexPath = self.indexPathForItem(at: endPoint),
            let targetCell = self.cellForItem(at: indexPath) as? SquareCell else {
                print("nothing found")
                return
        }
        if (!highlightedIndexPaths.contains(indexPath)){
            highlightedIndexPaths.append(indexPath)
        }
        //print("You touched: \(targetCell.letterLabel.text)")
        
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endPoint)
        drawPath.lineCapStyle = .round
        drawPath.lineJoinStyle = .round
        drawPath.close()
        
        let drawLayer = CAShapeLayer()
        drawLayer.name = "DrawLayer"
        drawLayer.frame = self.bounds
        drawLayer.fillColor = UIColor.red.cgColor
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.lineWidth = 20
        drawLayer.cornerRadius = 30
        drawLayer.path = drawPath.cgPath
        //print("CollectionView - \(self.delegate)")

        self.layer.addSublayer(drawLayer)
        self.setNeedsLayout()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var word = ""
        for indexPath in highlightedIndexPaths {
            if let cell = self.cellForItem(at: indexPath) as? SquareCell {
                word += cell.letterLabel.text ?? ""
            }
        }
        print("Final word: \(word)")
        highlightedIndexPaths = []
        clearCanvas()
    }
    
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
    
    private func snapY(theta: Double, x1: Double, x2 :Double, y1: Double) -> Double{
        return tan(theta)*(x2-x1) + y1
    }
    private func round(radian: Double) -> Double{
        let degree = Double(radian * 180 / .pi)
        if (degree >= 157.5){
            return 180
        }
        else if (degree >= 112.5){
            return 135
        }
        else if (degree >= 67.5){
            return 90
        }
        else if (degree >= 22.5){
            return 45
        }
        else if (degree >= -22.5){
            return 0
        }
        else if (degree >= -67.5){
            return -45
        }
        else if (degree >= -112.5){
            return -90
        }
        else if (degree >= -157.5){
            return -135
        }
        else{
            return 180
        }
    }
    
}
