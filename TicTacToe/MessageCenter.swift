//
//  MPCHandler.swift
//  MultiPeerTest
//
//  Created by Toby Thaliaparampil 2014 (N0562762) on 13/12/2017.
//  Copyright © 2017 Toby Thaliaparampil 2014 (N0562762). All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MessageCenter: NSObject, MCSessionDelegate {
    
    var peerID:MCPeerID!
    var multiplayerSession:MCSession!
    var contenterBrowser:MCBrowserViewController!
    var competitionAdvertiser:MCAdvertiserAssistant? = nil
    var gameService = "ul-tictactoe"
    
    func setupPeerWithDisplayName (displayName:String)
    {
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession()
    {
        multiplayerSession = MCSession(peer:peerID)
        
        multiplayerSession.delegate = self
        
    }
    
    func destroySession()
    {
        //multiplayerSession.disconnect()
        contenterBrowser.session.disconnect()
       // multiplayerSession = nil;
        
        self.advertiseSelf(advertise: false)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID,"state":state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotfication"), object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data": data,"peerID":peerID] as [String : Any]

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidRecieveDataNotfication"), object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    

    func setupbrowser()
    {
        contenterBrowser = MCBrowserViewController(serviceType: gameService, session: multiplayerSession)
        contenterBrowser.maximumNumberOfPeers = 2
    }
    
    func advertiseSelf(advertise:Bool)
    {
        if advertise{
            competitionAdvertiser = MCAdvertiserAssistant(serviceType: gameService, discoveryInfo: nil, session: multiplayerSession)
            competitionAdvertiser!.start()
        }else{
            competitionAdvertiser?.stop()
            competitionAdvertiser = nil
        }
        
    }
    
}

