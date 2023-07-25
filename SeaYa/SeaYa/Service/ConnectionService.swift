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
    
    //MARK: true - Host, false - Guest
    private var isHosting = false
    
    func host() {
        peers.removeAll()
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        
        let serviceType = ConnectionService.service
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
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
    
    func send<T: Codable>(_ data: T, messageType: MessageType) {
        guard
            let session = session,
            !session.connectedPeers.isEmpty
        else { return }
        
        let messageWrapper = MessageWrapper(messageType: messageType, data: data)
        do {
            let encodedData = try JSONEncoder().encode(messageWrapper)
            try session.send(encodedData, toPeers: session.connectedPeers, with: .reliable)
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
    
    func sendAllGuest(_ groupInfo: GroupInfo) {
        for _ in peers {
            send(groupInfo, messageType: .GroupInfo)
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
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any] {
                switch messageType {
                case .GroupInfo:
                    if let groupInfoData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo)
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let listUP = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        print(listUP)
                    }
                    
                case .GroupDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let groupDone = try JSONDecoder().decode(GroupDone.self, from: groupDoneData)
                        print(groupDone)
                    }
                }
            }
        } catch {
            print("Decoding error: \(error)")
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
            let data = try? Data(contentsOf: localURL)
        else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any] {
                switch messageType {
                case .GroupInfo:
                    if let groupInfoData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo)
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let listUP = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        print(listUP)
                    }
                    
                case .GroupDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let groupDone = try JSONDecoder().decode(GroupDone.self, from: groupDoneData)
                        print(groupDone)
                    }
                }
            }
        } catch {
            print("Decoding error: \(error)")
        }
    }
}
    
extension ConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !self.foundPeers.contains(peerID) {
            self.foundPeers.append(peerID)
        }
    }
        
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let index = foundPeers.firstIndex(of: peerID) {
            foundPeers.remove(at: index)
        }
    }
}
