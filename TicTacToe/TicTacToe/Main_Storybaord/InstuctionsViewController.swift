//
//  InstuctionsViewController.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 11/01/2018.
//  Copyright © 2018 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit

class InstuctionsViewController: UIViewController {
    
    let pdfName = "InstructionsForTicTacToe"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"){
            let instructionsWebView = UIWebView(frame:self.view.frame)
            let urlRequest = URLRequest(url:url)
            instructionsWebView.loadRequest(urlRequest as URLRequest)
            self.view.addSubview(instructionsWebView)
            
//            let instructionsVC = UIViewController()
//            instructionsVC.view.addSubview(instructionsWebView)
//            instructionsVC.title = pdfName
//            self.navigationController?.pushViewController(instructionsVC, animated: true)
            
        }
        

        // Do any additional setup after loading the view.
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
