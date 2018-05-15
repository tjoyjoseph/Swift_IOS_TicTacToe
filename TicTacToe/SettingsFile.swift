//
//  SettingsFile.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 06/12/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit

class SettingsFile {
    
    let fileName = "gameSettings.txt";
    var fileDirUrl:URL;
    
    var selectedDifficulty = 0;
    var selectedVolLevel:Float = 0;
    var playerName = "";
    
    
    init() {
        
        fileDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName);
        
    }
    
    private static var fileController = SettingsFile()
    
    static func initialize()
    {
        let allSettings:String = SettingsFile.retrieveFromFile();
        if allSettings == ""
        {
            fileController.selectedDifficulty = 0;
            fileController.selectedVolLevel = 0.6;
            fileController.playerName = "";
        }
        else
        {
            let combinedSettings = allSettings.components(separatedBy: ",")
            fileController.selectedDifficulty = Int(combinedSettings[0])!
            fileController.selectedVolLevel = Float(combinedSettings[1])!
            fileController.playerName = combinedSettings[2]
        }
    }
    
    static func changeSettings(difficulty:Int, vol:Float, name:String)
    {
        fileController.selectedDifficulty = difficulty;
        fileController.selectedVolLevel = vol;
        fileController.playerName = name;
        
    }
    
    static func getDifficulty() -> Int
    {
        return fileController.selectedDifficulty
    }
    
    static func getVolume() -> Float
    {
        return fileController.selectedVolLevel
    }
    
    static func getPlayerName() -> String
    {
        return fileController.playerName
    }
    
    static func setDifficulty(difficulty: Int)
    {
        fileController.selectedDifficulty = difficulty;
    }
    
    static func setVolume(volume: Float)
    {
        fileController.selectedVolLevel = volume
    }
    
    static func setPlayerName(name: String)
    {
        fileController.playerName = name
    }
    
    static func saveToFile()
    {
        let contents = String(fileController.selectedDifficulty)+","+String(fileController.selectedVolLevel)+","+String(fileController.playerName);
        do{
            try contents.write(to: fileController.fileDirUrl, atomically: true, encoding: String.Encoding.utf8);
            print("Writen to file" + contents)
        } catch let error as NSError{
            print("Failed to write to file")
            print (error)
        }
    }
    private static func retrieveFromFile() -> String
    {
        var fileContents: String = "";
        do{
            let fileExists = try fileController.fileDirUrl.checkResourceIsReachable();
            if fileExists
            {
                fileContents = try String(contentsOf:fileController.fileDirUrl);
                print("Reading File"+fileContents)
                
            }
        } catch let error as NSError {
            print("Failed to read from file")
            print (error)
        }
        
        return fileContents
    }
    
    
}

