//
//  WordSearch.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import Foundation
class WordSearch {
    private(set) var score = 0
    private(set) var gridSize = 10
    private(set) var words : [String]
    private(set) var wordsFound : [String]
    private(set) var grid : [[Letter]]
    
    init(words : [String]){
        self.wordsFound = [String]()
        self.words = [String]()
        grid = [[Letter]]()
        grid = (0..<gridSize).map({ _ in
            (0..<gridSize).map({ _ in Letter()})
        })
        for word in words {
            if (place(word: word.uppercased())){
                self.words.append(word.uppercased())
            }
        }
        fill()
    }
    
    
    /// Adds the given word at the given location to the grid
    ///
    /// - Parameters:
    ///   - word: word to add
    ///   - locations: the locations to place the letters of the word at
    private func updateGrid(withWord word: String, locations: [(column: Int, row: Int)]){
        if (word.count != locations.count){return}
        for (index,letter) in word.enumerated() {
            if (locations[index].column >= 0 && locations[index].column < gridSize && locations[index].row >= 0 && locations[index].row < gridSize ){
                grid[locations[index].column][locations[index].row].value = letter
            }
        }
    }
    
    
    /// Attempts to place the word given on the grid
    ///
    /// - Parameter word: word to place
    /// - Returns: true if the word is placed, false if the word is not placed
    private func place(word : String) -> Bool{
        let directions = PlacementDirection.allRandomCases
        for direction in directions {
            for column in (0..<gridSize).shuffled() {
                for row in (0..<gridSize).shuffled() {
                    if let locations = openLocations(for: word, from: (column: column, row: row), withDirection: direction){
                        updateGrid(withWord: word, locations: locations)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Finds the open locations for a word in a given direction. Open is defined as being either the location is occupied by the same letter or the location has no letter in it.
    ///
    /// - Parameters:
    ///   - word: word to find an open location for
    ///   - from: starting point
    ///   - direction: direction of which the method will try and place word in
    /// - Returns: an array of locations if possible, otherwise nil
    private func openLocations(for word: String, from : (column : Int, row: Int), withDirection direction: PlacementDirection) -> [(column : Int, row: Int)]?{
        var locations = [(column: Int, row: Int)]()
        var nextColumn = from.column
        var nextRow = from.row
        for letter in word {
            if(nextColumn < 0 || nextColumn >= gridSize || nextRow < 0 || nextRow >= gridSize){
                return nil
            }
            
            if(grid[nextColumn][nextRow].value == "*" || grid[nextColumn][nextRow].value == letter) {
                locations.append((column: nextColumn, row: nextRow))
                
            }
            else{
                return nil
            }
    
            nextColumn = nextColumn + direction.direction.column
            nextRow = nextRow + direction.direction.row
        }
        
        return locations
    }
   
    
    /// Fills any empty spots in the grid with the place holder '*'
    private func fill(){
        for column in 0..<gridSize {
            for row in 0..<gridSize {
                if (grid[column][row].value == "*"){
                    grid[column][row].value = Character.randomLetter()
                }
            }
        }
    }
    
    /// Verifies that a word is part of the word search
    ///
    /// - Parameter word: word to verify
    /// - Returns: true if the word is a target, false if not
    func verify(word: String) -> Bool{
        let reversedWord = String(word.reversed())
        if ((words.contains(word) && !wordsFound.contains(word)) || (words.contains(reversedWord) && !wordsFound.contains(reversedWord))){
            wordsFound.append(word)
            score += 1
            return true
        }
        return false
    }
    
    
    /// Prints word search grid
    func printGrid(){
        for column in 0..<gridSize {
            for row in 0..<gridSize {
                print(grid[column][row].value, terminator: "")
            }
            print("")
        }
    }
    
}
