//
//  ViewController.swift
//  WordSearch
//
//  Created by Santos on 2019-05-04.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, WordSearchViewDelegate {

    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var wordBankView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordSearchGrid: WordSearchView!
    @IBOutlet var wordBankLabels:[UILabel]!
    var game : WordSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWordBankView()
        setupGame()
        wordSearchGrid.wordSearchViewDelegate = self

    }
    func setupWordBankView(){
        let startColour = UIColor(named: "WSGreen") ?? UIColor.green
        let endColour = UIColor(named: "WSDarkGreen") ?? UIColor.green
        wordBankView.addGradientBackground(startColour: startColour, endColour: endColour)
    }
    
    func setupGame(){
        game = WordSearch(words: ["Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"])
        for (index,label) in wordBankLabels.enumerated() {
            label.text = game.words[index]
        }
    }
    ///WordSearchViewDelegate Methods
    func shouldRemainHightlighed(wordSearchView: WordSearchView, word: String) -> Bool {
        if (game.verify(word: word)){
            for label in wordBankLabels {
                if label.text?.lowercased() == word.lowercased() || label.text?.lowercased() == String(word.lowercased().reversed()){
                    UIView.animate(withDuration: 0.5) {
                        label.alpha = 0
                    }
                }
            }
            scoreLabel.text = "\(game.score)/\(game.words.count)"
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
            fatalError("Could not create LetterCell cell")
        }
        cell.letterLabel.text = String(game.grid[indexPath.section][indexPath.row].value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = wordSearchGrid.frame.height/10
        let width = height
        return CGSize(width: width, height: height)
    }
   
}

