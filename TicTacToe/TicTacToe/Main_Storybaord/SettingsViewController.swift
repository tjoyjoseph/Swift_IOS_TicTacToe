//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 25/10/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let computerDifficulties = ["Random","Defensive","Attack"];
    
    @IBOutlet weak var vwSettingsBackground: UIView!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblComputerDifficulty: UILabel!
    @IBOutlet weak var pckrVwDifficulty: UIPickerView!
    @IBOutlet weak var lblMusic: UILabel!
    @IBOutlet weak var sldMusicVol: UISlider!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var txtPlayerName: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtPlayerName.resignFirstResponder();
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.vwSettingsBackground.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return computerDifficulties[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return computerDifficulties.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch computerDifficulties[row]
        {
        case "Random":
            SettingsFile.setDifficulty(difficulty: 0)
            break;
        case "Defensive":
            SettingsFile.setDifficulty(difficulty: 1)
            break;
        case "Attack":
            SettingsFile.setDifficulty(difficulty: 2)
            break;
        default:
            break;
        }
        //lblComputerDifficulty.text = computerDifficulties[row];
    }

    @IBAction func pressSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        self.navigationController?.popViewController(animated: true)
        SettingsFile.setPlayerName(name: txtPlayerName.text!);
        SettingsFile.saveToFile()
    }
    
    @IBAction func ChangeAudioVolume(_ sender: Any) {
        AudioPlayer.stopAudio()
        AudioPlayer.setVolume(vol: sldMusicVol.value)
        SettingsFile.setVolume(volume: sldMusicVol.value)
        AudioPlayer.playAudio()
    }
    
    func rearrangeComponents(_ newSize: CGSize)
    {
            
            if newSize.width > newSize.height
            {
                self.vwSettingsBackground.frame = CGRect(x: 0, y:0, width: 900.0, height: 900.0)
                self.lblSettings.frame = CGRect(x: 70.0, y:20.0, width: 550.0, height: 66.0)
                self.lblComputerDifficulty.frame = CGRect(x: 63, y:160, width: 268, height: 39)
                self.pckrVwDifficulty.frame = CGRect(x: 53, y:190, width: 268, height: 123)
                self.lblMusic.frame = CGRect(x: 423, y:160, width: 198, height: 39)
                self.sldMusicVol.frame = CGRect(x: 421, y:240, width: 172, height: 30)
                self.lblPlayerName.frame = CGRect(x: 203, y:115, width: 112, height: 21)
                self.txtPlayerName.frame = CGRect(x: 316, y:110, width: 155, height: 30)
                self.btnSave.frame = CGRect(x: 279, y:320, width: 117, height: 35)
                
            } else {
                self.vwSettingsBackground.frame = CGRect(x: 0, y:0, width: 900, height: 900)
                self.lblSettings.frame = CGRect(x: 16, y:28, width: 343, height: 61)
                self.lblComputerDifficulty.frame = CGRect(x: 53, y:178, width: 268, height: 39)
                self.pckrVwDifficulty.frame = CGRect(x: 53, y:245, width: 268, height: 123)
                self.lblMusic.frame = CGRect(x: 53, y:397, width: 268, height: 39)
                self.sldMusicVol.frame = CGRect(x: 61, y:469, width: 272, height: 30)
                self.lblPlayerName.frame = CGRect(x: 45, y:123, width: 112, height: 21)
                self.txtPlayerName.frame = CGRect(x: 166, y:118, width: 155, height: 30)
                self.btnSave.frame = CGRect(x: 129, y:554, width: 117, height: 47)
            }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.rearrangeComponents(size)
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPlayerName.delegate = self;
        
        sldMusicVol.value = Float(SettingsFile.getVolume())
        
        pckrVwDifficulty.selectRow( SettingsFile.getDifficulty(), inComponent: 0, animated: true);
        
        print("Difficulty ", String(SettingsFile.getDifficulty()));
        print("Volume ", String(SettingsFile.getVolume()));
        
        txtPlayerName.text = SettingsFile.getPlayerName();
        
        //let screenSize: CGRect = UIScreen.main.bounds
       // DispatchQueue.global().async {
            //while true {
                var currentSize: CGSize = CGSize()
                currentSize.width = UIScreen.main.bounds.width
                currentSize.height = UIScreen.main.bounds.height
                self.rearrangeComponents(currentSize)
            //}
        //}
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

