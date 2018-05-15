//
//  Player.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 06/01/2018.
//  Copyright © 2018 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit

class Player: NSObject {
    override init() {}
    
    private static var playercontroller = Player()
    static var whichPlayer: Int = 1;
    
    static func getTacticalPositions () -> (Int,[Int],[Int])
    {
        var positions = [Int]();
        var posMarks = [Int]();
        var defaultSquare = Board.checkEmptySquares()[0];
        
        for i in Board.winSquares
        {
            if (Board.squareTrack[i[0]] != 0) && (Board.squareTrack[i[1]] != 0) && (Board.squareTrack[i[0]] == Board.squareTrack[i[1]] )
            {
                if Board.squareTrack[i[2]] == 0
                {
                    defaultSquare = i[2];
                    positions.append(i[2])
                    posMarks.append(Board.squareTrack[i[0]])
                }
            }
            else if (Board.squareTrack[i[0]] != 0) && (Board.squareTrack[i[2]] != 0) && (Board.squareTrack[i[0]] == Board.squareTrack[i[2]] )
            {
                if Board.squareTrack[i[1]] == 0
                {
                    defaultSquare = i[1];
                    positions.append(i[1])
                    posMarks.append(Board.squareTrack[i[0]])
                }
            }
            else if (Board.squareTrack[i[1]] != 0) && (Board.squareTrack[i[2]] != 0) && (Board.squareTrack[i[1]] == Board.squareTrack[i[2]] )
            {
                
                if Board.squareTrack[i[0]] == 0
                {
                    defaultSquare = i[0];
                    positions.append(i[0])
                    posMarks.append(Board.squareTrack[i[1]])
                }
            }
        }
        
        // let returnValues: (Int, [Int], [Int]) = (defaultSquare, positions, positionMarks);
        
        return (defaultSquare, positions, posMarks);
        
    }
    
    static func playerTurn(squareCode: Int)
    {
        switch whichPlayer {
        case 1:
            Board.squareTrack[squareCode] = 1;
            Board.allSquares[squareCode].image = UIImage(named: "naughts");
            whichPlayer = 2;
            break;
        case 2:
            Board.squareTrack[squareCode] = 2;
            Board.allSquares[squareCode].image = UIImage(named: "crosses");
            whichPlayer = 1;
            break;
        default:
            break;
        }
        
        
        
        
        Board.allSquares[squareCode].isUserInteractionEnabled = false;
    }
    
    
    
    
    

}
