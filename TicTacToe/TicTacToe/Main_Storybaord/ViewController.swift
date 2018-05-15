//
//  ViewController.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 20/10/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var lblDoYouDare: UILabel!
    
    @IBOutlet weak var imgTicTacToeImage: UIImageView!
    
    @IBOutlet weak var lblTicTactoe: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnPlayGame: UIButton!
    @IBOutlet weak var vwOpenScreen: UIView!
    
    @IBOutlet weak var btnInstructions: UIButton!
    let pdfName = "InstructionsForTicTacToe"
    
    @IBOutlet weak var vwMenu: UIView!
    
    func rearrangeComponents(_ newSize: CGSize)
    {
        DispatchQueue.main.async {
            
            if newSize.width > newSize.height
            {
                self.vwOpenScreen.frame = CGRect(x: 0, y:0, width: 900, height: 900)
                self.vwMenu.frame = CGRect(x: 0, y:0, width: 900, height: 900)
                self.lblTicTactoe.frame = CGRect(x: 55.0, y:25.0, width: 550.0, height: 66.0)
                self.lblDoYouDare.frame = CGRect(x: 50.0, y:90.0, width: 550.0, height: 66.0)
                self.imgTicTacToeImage.frame = CGRect(x: 200.0, y:130.0, width: 250.0, height: 250.0)
                self.btnPlayGame.frame = CGRect(x: 70.0, y:100.0, width: 500, height: 66.0)
                self.btnSettings.frame = CGRect(x: 70.0, y:180, width: 500, height: 66.0)
                self.btnInstructions.frame = CGRect(x: 70, y:260, width: 500, height: 66.0)
            } else {
                self.vwOpenScreen.frame = CGRect(x: 0, y:0, width: 900, height: 900)
                self.vwMenu.frame = CGRect(x: 0, y:0, width: 900, height: 900)
                self.lblTicTactoe.frame = CGRect(x: 0, y:70, width: 378, height: 61)
                self.lblDoYouDare.frame = CGRect(x: 8, y:146, width: 359, height: 45)
                self.imgTicTacToeImage.frame = CGRect(x: 0, y:164, width: 376, height: 402)
                self.btnPlayGame.frame = CGRect(x: 49, y:200, width: 277, height: 57)
                self.btnSettings.frame = CGRect(x: 49, y:310, width: 277, height: 57)
                self.btnInstructions.frame = CGRect(x: 49, y:410, width: 277, height: 57)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.rearrangeComponents(size)

        })
    }
    
    @IBAction func pressBtnInstructions(_ sender: Any) {
        
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"){
            let instructionsWebView = UIWebView(frame:self.view.frame)
            let urlRequest = URLRequest(url:url)
            instructionsWebView.loadRequest(urlRequest as URLRequest)
            self.view.addSubview(instructionsWebView)
            
            let instructionsVC = UIViewController()
            instructionsVC.view.addSubview(instructionsWebView)
            instructionsVC.title = pdfName
            self.navigationController?.pushViewController(instructionsVC, animated: true)
            
            self.navigationController?.isNavigationBarHidden = false
        }
        
        
    }
    
    
    
    
    @IBOutlet weak var btnConnect: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsFile.initialize();
        AudioPlayer.setVolume(vol: SettingsFile.getVolume())
        
        AudioPlayer.playAudio();

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            self.lblDoYouDare.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                self.vwOpenScreen.isHidden = true
                self.vwMenu.isHidden = false
            }
        }
        
        //let screenSize: CGRect = UIScreen.main.bounds
       // DispatchQueue.global().async {
            //while true {
                var currentSize: CGSize = CGSize()
                currentSize.width = UIScreen.main.bounds.width
                currentSize.height = UIScreen.main.bounds.height
                self.rearrangeComponents(currentSize)
           // }
       // }
        
        
    self.navigationController?.isNavigationBarHidden = true
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

