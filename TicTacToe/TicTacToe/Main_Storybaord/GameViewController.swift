//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 25/10/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//


/////Bug Report

///////////////////
import UIKit
import MultipeerConnectivity


class GameViewController: UIViewController, MCBrowserViewControllerDelegate  {
    
    @IBOutlet weak var imgSq1: UIImageView!
    @IBOutlet weak var imgSq2: UIImageView!
    @IBOutlet weak var imgSq3: UIImageView!
    @IBOutlet weak var imgSq4: UIImageView!
    @IBOutlet weak var imgSq5: UIImageView!
    @IBOutlet weak var imgSq6: UIImageView!
    @IBOutlet weak var imgSq7: UIImageView!
    @IBOutlet weak var imgSq8: UIImageView!
    @IBOutlet weak var imgSq9: UIImageView!
    
    @IBOutlet var tapSq1: UITapGestureRecognizer!
    @IBOutlet var tapSq2: UITapGestureRecognizer!
    @IBOutlet var tapSq3: UITapGestureRecognizer!
    @IBOutlet var tapSq4: UITapGestureRecognizer!
    @IBOutlet var tapSq5: UITapGestureRecognizer!
    @IBOutlet var tapSq6: UITapGestureRecognizer!
    @IBOutlet var tapSq7: UITapGestureRecognizer!
    @IBOutlet var tapSq8: UITapGestureRecognizer!
    @IBOutlet var tapSq9: UITapGestureRecognizer!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnDisconnect: UIButton!
    @IBOutlet weak var lblConnectionStatus: UILabel!
    @IBOutlet weak var lblPlayerIdentifier: UILabel!
    @IBOutlet weak var btnComputer: UIButton!
    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var vwGameBackground: UIImageView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var vwGameBoard: UIImageView!
    @IBOutlet weak var vwBackground: UIView!
    
    var multiplayer = false
    var winnerDeclared = false;
    var tie = false
    var gameOnPlay = true
    
    var appDelegate:AppDelegate!
    
    @IBAction func btnPressConnect(_ sender: Any) {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var playerName = UIDevice.current.name
        if (SettingsFile.getPlayerName() != ""){
            playerName = SettingsFile.getPlayerName();
        }
        
        appDelegate.messageSystem.setupPeerWithDisplayName(displayName: playerName)
        appDelegate.messageSystem.setupSession()
        appDelegate.messageSystem.advertiseSelf(advertise: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerChangeSelfWithNotification), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotfication"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlerRecieveDataWithNotification), name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotfication"), object: nil)
        
        if appDelegate.messageSystem.multiplayerSession != nil{
            appDelegate.messageSystem.setupbrowser()
            appDelegate.messageSystem.contenterBrowser.delegate = self
            self.present(appDelegate.messageSystem.contenterBrowser,animated: true, completion: nil)
        }
    }
    
    
    @objc func peerChangeSelfWithNotification(notification:Notification)
    {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state =  userInfo.object(forKey: "state") as! Int
        let senderPeerID:MCPeerID = userInfo["peerID"] as! MCPeerID
        
        if state == MCSessionState.connected.rawValue{
            
            btnConnect.isHidden = true;
            btnDisconnect.isHidden = false;
            
            self.lblConnectionStatus.isHidden = false
            self.lblConnectionStatus.text = "Connected to "+" "+senderPeerID.displayName
            multiplayer = true;
        }
        else if state == MCSessionState.notConnected.rawValue
        {
            btnConnect.isHidden = false;
            btnDisconnect.isHidden = true;
            lblConnectionStatus.isHidden = true;
            multiplayer = false;
            setAlert(theTitle: "Player Disconnected", theMessage: "Game Ended")
            appDelegate.messageSystem.destroySession()
        }
        else if state != MCSessionState.connected.rawValue
        {
            appDelegate.messageSystem.destroySession()
            
        }
        reset()
        
    }
    
    @objc func handlerRecieveDataWithNotification (notification:Notification)
    {
        let userInfo = notification.userInfo! as Dictionary
        let recievedData:NSData = userInfo["data"] as! NSData
        var message:NSDictionary
        
        do {
            message = try JSONSerialization.jsonObject(with: recievedData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let toReset = message.object(forKey: "reset") as! Bool
            if toReset == true{
                reset()
            }else{
                Player.whichPlayer = message.object(forKey: "playernum") as! Int
                print(Player.whichPlayer)
                Player.playerTurn(squareCode: message.object(forKey: "squareCode") as! Int)
                
                ///checkGame();
                if (winnerDeclared || tie ) != true {
                    disableGame(enableDisable:true);
                }
                if Player.whichPlayer == 2 && lblPlayerIdentifier.isHidden == true
                {
                    lblPlayerIdentifier.isHidden = false
                    lblPlayerIdentifier.text = "You are crosses"
                }
                
            }
            
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    @IBAction func btnPressDisconnect(_ sender: Any) {
        appDelegate.messageSystem.destroySession()
    }
    
    
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        self.navigationController?.popViewController(animated: true)
    }
    
    func reset()
    {
        resetAllSquares()
        
        imgLine.isHidden = false;
        lblPlayerIdentifier.isHidden = true
        disableGame(enableDisable:true);
        
        Player.whichPlayer = 1;
        winnerDeclared = false
        tie = false
        
        Board.squareTrack = [0,0,0,0,0,0,0,0,0];
        
        gameOnPlay = true
        
        
    }
    
    @IBAction func pressReset(_ sender: Any) {
        if multiplayer == true
        {
            sendMessage(square: 10, reset: true, playernum: 0)
        }
        reset()
    }
    
    func disableGame(enableDisable: Bool)
    {
        for i in Board.allSquares
        {
            i.isUserInteractionEnabled = enableDisable;
        }
        btnComputer.isHidden = !enableDisable;
    }
    
    func resetAllSquares()
    {
        for i in Board.allSquares
        {
            i.image = UIImage();
        }
        imgLine.image = UIImage();
    }
    
    func drawLine( position: String) -> Bool
    {
        self.imgLine.isHidden = false;
        self.imgLine.image = UIImage(named: position);
        return true;
    }
    
    
    func checkGame()
    {
        let winLines = ["Hor_Top","diag_LeftRight","Ver_Left","Ver_Right","Hor_Mid","Ver_Mid","Diag_RightLeft","Hor_Bottom"];
        
        var i = 0;
        for winSqare in Board.winSquares
        {
            if Board.squareTrack[winSqare[0]] != 0
            {
                if Board.squareTrack[winSqare[0]] == Board.squareTrack[winSqare[1]] && Board.squareTrack[winSqare[1]] == Board.squareTrack[winSqare[2]]
                {
                    DispatchQueue.main.async {
                    self.winnerDeclared = self.drawLine(position: winLines[i]);
                    self.disableGame(enableDisable:false);
                    self.gameOnPlay = false
                    }
                    
                    switch Board.squareTrack[winSqare[0]]
                    {
                    case 1:
                        setAlert(theTitle: "CONGRATULATIONS", theMessage: "Player Naughts Wins!");
                        break;
                    case 2:
                        setAlert(theTitle: "CONGRATULATIONS", theMessage: "Player Crosses Wins!");
                        break;
                    default:
                        break;
                    }
                }
            }
            i = i + 1;
        }
        let allEmptySquares = Board.checkEmptySquares();
        
        if allEmptySquares.count == 0 && winnerDeclared == false
        {
            tie = true
            DispatchQueue.main.async {
            self.setAlert(theTitle: "Booo!", theMessage: "Its a TIE!")
            self.btnComputer.isHidden = true;
             self.gameOnPlay = false
            }
            
        }
    }
    
    func setAlert(theTitle: String,theMessage: String)
    {
        let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    
    func sendMessage(square: Int?, reset: Bool?, playernum: Int?)
    {
        let messageDict = ["squareCode":square!,"reset":reset!, "playernum":playernum!] as [String : Any]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            try appDelegate.messageSystem.multiplayerSession.send(messageData, toPeers: appDelegate.messageSystem.multiplayerSession.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    @IBAction func pressBtnComputer(_ sender: UIButton) {
        var chosenSquare:Int = 10;
        if SettingsFile.getDifficulty() == 2
        {
            chosenSquare = Player.getTacticalPositions().0;
            var possiblePositions = Player.getTacticalPositions ().1;
            var positionMarks = Player.getTacticalPositions ().2;
            
            for i in 0..<possiblePositions.count
            {
                if positionMarks[i] == Player.whichPlayer
                {
                    chosenSquare = possiblePositions[i];
                    break;
                }
            }
            
            if possiblePositions.count == 0
            {
                let valueSquares = [0,2,6,8,4];
                for i in valueSquares
                {
                    if Board.squareTrack[i] == 0
                    {
                        chosenSquare = i;
                        break;
                    }
                }
            }
            
        }
        else if SettingsFile.getDifficulty() == 1
        {
            chosenSquare = Player.getTacticalPositions ().0;
            var possiblePositions = Player.getTacticalPositions ().1;
            var positionMarks = Player.getTacticalPositions ().2;
            if possiblePositions.count > 0
            {
                for i in 0..<possiblePositions.count
                {
                    if positionMarks[i] != Player.whichPlayer
                    {
                        chosenSquare = possiblePositions[i];
                        break;
                    }
                }
            }
            else
            {
                let allEmptySquares = Board.checkEmptySquares()
                chosenSquare = allEmptySquares[Int(arc4random_uniform(UInt32(allEmptySquares.count)))]
                
            }
            
        }
        else if SettingsFile.getDifficulty() == 0
        {
            let allEmptySquares = Board.checkEmptySquares()
            chosenSquare = allEmptySquares[Int(arc4random_uniform(UInt32(allEmptySquares.count)))]
        }
        
        if multiplayer == true{
            sendMessage(square: chosenSquare, reset: false, playernum: Player.whichPlayer)
            disableGame(enableDisable:false);
            if lblPlayerIdentifier.isHidden == true && Player.whichPlayer == 1
            {
                lblPlayerIdentifier.isHidden = false
                lblPlayerIdentifier.text = "You are Naughts"
            }
        }
        Player.playerTurn(squareCode: chosenSquare);
        ////checkGame();
    }
    
    @IBAction func touchSq(_ sender: UITapGestureRecognizer) {
        let square = Int(sender.accessibilityLabel!)
        
        if multiplayer == true{
            sendMessage(square: square!, reset: false, playernum: Player.whichPlayer)
            disableGame(enableDisable:false);
            if lblPlayerIdentifier.isHidden == true && Player.whichPlayer == 1
            {
                lblPlayerIdentifier.isHidden = false
                lblPlayerIdentifier.text = "You are Naughts"
            }
        }
        
        Player.playerTurn(squareCode: square!);
        ///checkGame();
    }
    
    func rearrangeComponents(_ newSize: CGSize)
    {
        if newSize.width > newSize.height
        {
            self.vwBackground.frame = CGRect(x: 0, y:0, width: 900, height: 900)
            self.vwGameBackground.frame = CGRect(x: 120, y:0, width: 400.0, height: 250.0)
            self.vwGameBoard.frame = CGRect(x: 195, y:67, width: 250, height: 250)
            
            self.btnBack.frame = CGRect(x: 22, y:20, width: 107, height: 35)
            self.btnConnect.frame = CGRect(x: 537, y:20, width: 115, height: 35)
            self.btnDisconnect.frame = CGRect(x: 537, y:20, width: 115, height: 35)
            self.lblConnectionStatus.frame = CGRect(x: 160, y:20, width: 330, height: 33)
            
            self.imgSq1.frame = CGRect(x: 180, y:62, width: 101, height: 100)
            self.imgSq2.frame = CGRect(x: 270, y:62, width: 101, height: 100)
            self.imgSq3.frame = CGRect(x: 350, y:62, width: 101, height: 100)
            self.imgSq4.frame = CGRect(x: 180, y:142, width: 101, height: 100)
            self.imgSq5.frame = CGRect(x: 270, y:142, width: 101, height: 100)
            self.imgSq6.frame = CGRect(x: 350, y:142, width: 101, height: 100)
            self.imgSq7.frame = CGRect(x: 180, y:223, width: 101, height: 100)
            self.imgSq8.frame = CGRect(x: 270, y:223, width: 101, height: 100)
            self.imgSq9.frame = CGRect(x: 350, y:223, width: 101, height: 100)
            
            self.imgLine.frame = CGRect(x: 195, y:67, width: 250, height: 250)
            
            self.lblPlayerIdentifier.frame = CGRect(x: 160, y:330, width: 330, height: 44)
            self.btnComputer.frame = CGRect(x: 22, y:330, width: 107, height: 35)
            self.btnReset.frame = CGRect(x: 537, y:330, width: 115, height: 35)
            
            
        } else {
            self.vwBackground.frame = CGRect(x: 0, y:0, width: 900, height: 900)
            self.vwGameBackground.frame = CGRect(x: 0, y:0, width: 375, height: 554)
            self.vwGameBoard.frame = CGRect(x: 22, y:166, width: 330, height: 336)
            self.btnBack.frame = CGRect(x: 22, y:52, width: 107, height: 44)
            self.btnConnect.frame = CGRect(x: 237, y:52, width: 115, height: 44)
            self.btnDisconnect.frame = CGRect(x: 237, y:52, width: 115, height: 44)
            self.lblConnectionStatus.frame = CGRect(x: 22, y:112, width: 330, height: 33)
            self.imgSq1.frame = CGRect(x: 30, y:172, width: 101, height: 100)
            self.imgSq2.frame = CGRect(x: 136, y:172, width: 101, height: 100)
            self.imgSq3.frame = CGRect(x: 246, y:172, width: 101, height: 100)
            self.imgSq4.frame = CGRect(x: 28, y:282, width: 101, height: 100)
            self.imgSq5.frame = CGRect(x: 137, y:282, width: 101, height: 100)
            self.imgSq6.frame = CGRect(x: 247, y:282, width: 101, height: 100)
            self.imgSq7.frame = CGRect(x: 30, y:393, width: 101, height: 100)
            self.imgSq8.frame = CGRect(x: 138, y:393, width: 101, height: 100)
            self.imgSq9.frame = CGRect(x: 248, y:393, width: 101, height: 100)
            self.imgLine.frame = CGRect(x: 47, y:172, width: 291, height: 303)
            self.lblPlayerIdentifier.frame = CGRect(x: 22, y:510, width: 330, height: 44)
            self.btnComputer.frame = CGRect(x: 22, y:605, width: 107, height: 44)
            self.btnReset.frame = CGRect(x: 237, y:605, width: 115, height: 44)
            
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
        
        self.navigationController?.isNavigationBarHidden = true
        
        Board.allSquares = [self.imgSq1,self.imgSq2,self.imgSq3,self.imgSq4,self.imgSq5,self.imgSq6,self.imgSq7,self.imgSq8,self.imgSq9];
        
        tapSq1.accessibilityLabel = "0";
        tapSq2.accessibilityLabel = "1";
        tapSq3.accessibilityLabel = "2";
        tapSq4.accessibilityLabel = "3";
        tapSq5.accessibilityLabel = "4";
        tapSq6.accessibilityLabel = "5";
        tapSq7.accessibilityLabel = "6";
        tapSq8.accessibilityLabel = "7";
        tapSq9.accessibilityLabel = "8";
        
        let width: CGFloat = 640
        let height: CGFloat = 640
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
        
        var currentSize: CGSize = CGSize()
        currentSize.width = UIScreen.main.bounds.width
        currentSize.height = UIScreen.main.bounds.height
        self.rearrangeComponents(currentSize)
        
        
        /////////////
                DispatchQueue.global(qos: .userInteractive).async {
                    while true {
                        if self.gameOnPlay == true {
                         self.checkGame()
                        }
                    }
        
                }
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.messageSystem.contenterBrowser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.messageSystem.contenterBrowser.dismiss(animated: true, completion: nil)
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
