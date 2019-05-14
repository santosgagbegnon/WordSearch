//
//  ViewController.swift
//  WordSearch
//
//  Created by Santos on 2019-05-04.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, WordSearchViewDelegate {

    @IBOutlet weak var wordSearchGrid: WordSearchView!
    @IBOutlet var wordBankLabels:[UILabel]!
    var game : WordSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        wordSearchGrid.wordSearchViewDelegate = self
        
       // wordSearchGrid.flow
        // Do any additional setup after loading the view.
//         drawaLine()
    }
    func setupGame(){
        game = WordSearch(words: ["UZI", "KANYE", "DRAKE", "TORY", "CARTI", "NAV"])
        for (index,label) in wordBankLabels.enumerated() {
            label.text = game.words[index]
        }
        
        
    }
    func drawaLine(){
        print("called")
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 10))
        path.addLine(to: CGPoint(x: 100, y: 10))
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
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
    
    func shouldRemainHightlighed(wordSearchView: WordSearchView, word: String) -> Bool {
        if (game.words.contains(word)){
            print("Word found:\(word)")
            return true
        }
        return false
    }
}

extension GameViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return game.gridSize
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCell", for: indexPath) as? LetterCell else{
            fatalError("Could not create proper cell")
        }
        cell.letterLabel.text = String(game.grid[indexPath.section][indexPath.row].value)//String.randomLetter()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Ok -")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = wordSearchGrid.frame.height/10
        let width = height
        return CGSize(width: width, height: height)
    }
   
}

