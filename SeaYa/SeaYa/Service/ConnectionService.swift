//
//  ConnectionService.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/24.
//

import Foundation
import MultipeerConnectivity

class ConnectionService: NSObject, ObservableObject {
    private static let service = "ou-SeaYa"
    private static let userName = "Helia"
   
    @Published var peers: [MCPeerID] = []
    @Published var foundPeers: [MCPeerID] = []
    @Published var connected = false
    @Published var reciveData = ""

    let myPeerId = MCPeerID(displayName: userName)
    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    var session: MCSession?
    var browser: MCNearbyServiceBrowser?
    private var isHosting = false
    
    func host() {
        peers.removeAll()
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        
        let serviceType = ConnectionService.service
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
        print("host")
    }

    func guest() {
        isHosting = true
        peers.removeAll()
        connected = true
        session = MCSession(
            peer: myPeerId,
            securityIdentity: nil,
            encryptionPreference: .required
        )

        session?.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: nil,
            serviceType: ConnectionService.service
        )
        
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
    }
    
    func send(_ message: String) {
        guard
            let session = session,
            let data = message.data(using: .utf8),
            !session.connectedPeers.isEmpty
        else { return }

        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func leaveSession() {
        isHosting = false
        connected = false
        advertiserAssistant?.stopAdvertisingPeer()
        session = nil
        advertiserAssistant = nil
    }
    
    func sendAllGuest() {
        for peer in peers {
            send("hello \(peer.displayName)")
        }
    }
}

extension ConnectionService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}


extension ConnectionService: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else { return }
        DispatchQueue.main.async {
            self.reciveData = message
            print(self.reciveData)
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            if !peers.contains(peerID) {
                DispatchQueue.main.async {
                    self.peers.insert(peerID, at: 0)
                    print("connected")
                }
            }
        case .notConnected:
            DispatchQueue.main.async {
                print("not connected")
                if let index = self.peers.firstIndex(of: peerID) {
                    self.peers.remove(at: index)
                }
                if self.peers.isEmpty && !self.isHosting {
                    self.connected = false
                }
            }
        case .connecting:
            print("Connecting to: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state: \(state)")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving chat history")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard
            let localURL = localURL,
            let data = try? Data(contentsOf: localURL),
            let message = try? JSONDecoder().decode(String.self, from: data)
        else { return }
        reciveData = message

        print(data)
    }
}

extension ConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !self.foundPeers.contains(peerID) {
            self.foundPeers.append(peerID)
            print(foundPeers)
        }
    }
        
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let index = foundPeers.firstIndex(of: peerID) {
            foundPeers.remove(at: index)
        }
    }
}
