//
//  ConnectionService.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/24.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

struct CheckTimeDone: Codable {
    var isCheckTimeDone: Bool
}

class ConnectionService: NSObject, ObservableObject {
    private static let service = "ou-SeaYa"
   
    //MARK: all connected guest list
    @Published var peers: [(peer: MCPeerID, value: String)] = []
    @Published var foundPeers: [(peer: MCPeerID, value: String)] = []
    @Published var connected = false
    @Published var groupInfo: GroupInfo?
    @Published var listUP: [DateMember] = []
    @Published var isCheckTimeDone: CheckTimeDone = CheckTimeDone(isCheckTimeDone: false)
    @Published var scheduleDone: ScheduleDone?
    
    @Published var listUpViewResult : ListUpViewResult?

    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    var session: MCSession?
    var browser: MCNearbyServiceBrowser?
    
    //MARK: true - Guest, false - Host
    var isHosting = false
    
    //Host function
    func host(_ nickName: String) {
        if nickName != ""{
            let myPeerId = MCPeerID(displayName: nickName)
            
            peers.removeAll()
            foundPeers.removeAll()
            
            //create session
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session?.delegate = self
            
            let serviceType = ConnectionService.service
            
            //find near by device
            browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
            browser?.delegate = self
            browser?.startBrowsingForPeers()
        }
    }
    
    //Guest function
    func guest(_ nickName: String, _ index: String) {
        let myPeerId = MCPeerID(displayName: nickName)
        
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
            discoveryInfo: ["imageName": index],
            serviceType: ConnectionService.service
        )
        
        //start Advertise
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
        
        print(myPeerId)
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
    
    func sendGroupInfoToGuest(_ info: GroupInfo) {
        send(info, messageType: .GroupInfo)
    }
    
    func sendTimeTableInfoToHost(_ info: DateMember) {
        send(info, messageType: .ListUP)
    }
    
    func sendScheduleInfoToGuest(_ info: ScheduleDone) {
        send(info, messageType: .ScheduleDone)
    }
    
    func sendListUPInfoToGuest(_ info: ListUpViewResult){
        send(info, messageType: .ListUpViewResult)
    }
    
    func setGroupInfo(_ info: GroupInfo) {
        groupInfo = info
    }
    
    func setScheduleInfo(_ info: ScheduleDone) {
        scheduleDone = info
    }
    
    func setListUpViewResult(_ info : ListUpViewResult){
        listUpViewResult = info
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
    
    //ReciveData
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any] {
                switch messageType {
                case .GroupInfo:
                    if let groupInfoData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo ?? "")
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let data = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        listUP.append(data)
                        print(listUP ?? "")
                    }
                    
                case .ScheduleDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        scheduleDone = try JSONDecoder().decode(ScheduleDone.self, from: groupDoneData)
                        print(scheduleDone ?? "")
                    }
                    
                case .CheckTimeDone:
                    if let isCheckTimeDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        isCheckTimeDone = try JSONDecoder().decode(CheckTimeDone.self, from: isCheckTimeDoneData)
                    }
                case .ListUpViewResult:
                    if let isCheckTimeDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        listUpViewResult = try JSONDecoder().decode(ListUpViewResult.self, from: isCheckTimeDoneData)
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
            if !peers.contains(where: {$0.peer == peerID}) && peers.count < 7{
                DispatchQueue.main.async {
                    self.peers.append((peer: peerID, value: self.foundPeers.filter{$0.peer == peerID}.first?.value ?? "01"))
                    print("connected")
                }
            }
            
        case .notConnected:
            DispatchQueue.main.async {
                print("not connected")
                
                if let index = self.peers.firstIndex(where: {$0.peer == peerID}) {
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
                        groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo ?? "")
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let data = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        listUP.append(data)
                        print(listUP ?? "")
                    }
                    
                case .ScheduleDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        scheduleDone = try JSONDecoder().decode(ScheduleDone.self, from: groupDoneData)
                        print(scheduleDone ?? "")
                    }
                    
                case .CheckTimeDone:
                    if let isCheckTimeDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        isCheckTimeDone = try JSONDecoder().decode(CheckTimeDone.self, from: isCheckTimeDoneData)
                    }
                case .ListUpViewResult:
                    if let nunnuna = try? JSONSerialization.data(withJSONObject: jsonData) {
                        listUpViewResult = try JSONDecoder().decode(ListUpViewResult.self, from: nunnuna)
                        print(listUpViewResult ?? "")
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
        //MARK: value 수정
        if !self.foundPeers.contains(where: {$0.peer == peerID }){
            if let value = info?.first?.value {
                self.foundPeers.append((peer: peerID, value: value))
            }
        }
        
        print(self.foundPeers)
    }
        
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID)
        if let index = foundPeers.firstIndex(where: {$0.peer == peerID}) {
            foundPeers.remove(at: index)
        }
    }
}
