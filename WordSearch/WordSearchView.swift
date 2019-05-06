//
//  WordSearchView.swift
//  WordSearch
//
//  Created by Santos on 2019-05-05.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class WordSearchView: UICollectionView {
    
    var startingPoint : CGPoint!
    var endPoint : CGPoint!
    var drawPath : UIBezierPath!
   
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        startingPoint = touch.location(in: self)
        
        print("touches began")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        clearCanvas()
        endPoint = touch.location(in: self)//CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).x )
        let startX = startingPoint.x
        let startY = startingPoint.y
        let endX = endPoint.x
        let endY = endPoint.y
        
        let opposite = endY - startY
        let adjacent = endX - startX
        
        let angle = Double(atan2(opposite, adjacent))
        let aid = (round(degree: rad2deg(angle))) * Double.pi/180
        if (abs(aid * 180/Double.pi) == 90) {
            print("90 ting")
            endPoint = CGPoint(x: startingPoint.x, y: touch.location(in: self).y)
        }
        else{
            let newY = snapY(theta: aid, x1: Double(startX), x2: Double(endX), y1: Double(startY))
            endPoint = CGPoint(x: endPoint.x, y: CGFloat(newY))
        }
        print("Angle: \( round(degree: rad2deg(angle)) )")
    
        drawPath = UIBezierPath()
        drawPath.move(to: startingPoint)
        drawPath.addLine(to: endPoint)
        drawPath.lineCapStyle = .round
        drawPath.close()
        
        let drawLayer = CAShapeLayer()
        drawLayer.name = "DrawLayer"
        drawLayer.frame = self.bounds
        drawLayer.fillColor = UIColor.red.cgColor
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.lineWidth = 20
        drawLayer.path = drawPath.cgPath
      //  drawLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/2), 0, 0, 1.0)
        self.layer.addSublayer(drawLayer)
        self.setNeedsLayout()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearCanvas()
    }
    
    private func clearCanvas(){
        let x = tan(CGFloat(45))
        print("Tan: \(x)")
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
    
    /*
     22.5
     67.5
     112.5
     157.5
     202.5
     247.5
     292.5
     337.5
     */
    
    private func snapY(theta: Double, x1: Double, x2 :Double, y1: Double) -> Double{
//        if(theta == 90 || theta == -90){
//            return nil
//        }
        return tan(theta)*(x2-x1) + y1
    }
    private func round(degree: Double) -> Double{
//        if (degree >= 157.5){
//            return 180
//        }
//        else if (degree >= 112.5){
//            return 225
//        }
//        else if (degree >= 67.5){
//            return 270
//        }
//        else if (degree >= 22.5){
//            return 315
//        }
//        else if (degree >= -22.5){
//            return 0
//        }
//        else if (degree >= -67.5){
//            return 45
//        }
//        else if (degree >= -112.5){
//            return 90
//        }
//        else if (degree >= -157.5){
//            return 135
//        }
//        else{
//            return 180
//        }
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
    
    func rad2deg(_ number: Double) -> Double {
        return Double(number * 180 / .pi)
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
