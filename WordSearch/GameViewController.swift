//
//  ViewController.swift
//  WordSearch
//
//  Created by Santos on 2019-05-04.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var wordSearchGrid: WordSearchView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // drawaLine()
    }
    
    func drawaLine(){
        print("called")
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 10))
        path.addLine(to: CGPoint(x: 100, y: 10))
        path.close()
        
        let drawLayer = CAShapeLayer()
        drawLayer.frame = wordSearchGrid.bounds
        drawLayer.cornerRadius = 10
        drawLayer.fillColor = UIColor.red.cgColor
        drawLayer.opacity = 0.8
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.lineWidth = 32
        drawLayer.path = path.cgPath
        
        wordSearchGrid.layer.addSublayer(drawLayer)
    }
    
}

extension GameViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCell", for: indexPath) as? LetterCell else{
            fatalError("Could not create proper cell")
        }
        cell.letterLabel.text = String.randomLetter()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Ok -")
    }
   
}

