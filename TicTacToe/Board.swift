//
//  Board.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 14/12/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit

class Board: NSObject {
    
    override init() {}
    
    private static var boardController = Board()
    
    static var squareTrack = [0,0,0,0,0,0,0,0,0];
    
    static var allSquares = [UIImageView]();
    
    static let winSquares = [[0,1,2],
                      [0,4,8],
                      [0,3,6],
                      [8,5,2],
                      [3,4,5],
                      [1,4,7],
                      [2,4,6],
                      [6,7,8]];
    
    static func checkEmptySquares () -> [Int]
    {
        var emptySquares = [Int]();
        
        for x in 0..<squareTrack.count
        {
            if squareTrack[x] == 0
            {
                emptySquares.append(x)
            }

        }
        
        return emptySquares;
    }
    
    
    
    
    

}
