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

    // MARK: all connected guest list

    @Published var peers: [(peer: MCPeerID, value: String)] = []
    @Published var foundPeers: [(peer: MCPeerID, value: String)] = []
    @Published var connected = false
    @Published var groupInfo: GroupInfo?
    @Published var listUP: [DateMember] = []
    @Published var isCheckTimeDone: CheckTimeDone = .init(isCheckTimeDone: false)
    @Published var scheduleDone: ScheduleDone?

    @Published var listUpViewResult: ListUpViewResult?

    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    var session: MCSession?
    var browser: MCNearbyServiceBrowser?

    // MARK: true - Guest, false - Host

    var isHosting = false

    // Host function
    func host(_ nickName: String) {
        if nickName != "" {
            let myPeerId = MCPeerID(displayName: nickName)

            peers.removeAll()
            foundPeers.removeAll()

            // create session
            session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
            session?.delegate = self

            let serviceType = ConnectionService.service

            // find near by device
            browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
            browser?.delegate = self
            browser?.startBrowsingForPeers()
        }
    }

    // Guest function
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

        // start Advertise
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

    func sendListUPInfoToGuest(_ info: ListUpViewResult) {
        send(info, messageType: .ListUpViewResult)
    }

    func setGroupInfo(_ info: GroupInfo) {
        groupInfo = info
    }

    func setScheduleInfo(_ info: ScheduleDone) {
        scheduleDone = info
    }

    func setListUpViewResult(_ info: ListUpViewResult) {
        listUpViewResult = info
    }
}

extension ConnectionService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer _: MCPeerID,
                    withContext _: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        invitationHandler(true, session)
    }
}

extension ConnectionService: MCSessionDelegate {
    // ReciveData
    func session(_: MCSession, didReceive data: Data, fromPeer _: MCPeerID) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any]
            {
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
                        print(listUP)
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

    func session(_: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            if !peers.contains(where: { $0.peer == peerID }) && peers.count < 7 {
                DispatchQueue.main.async {
                    self.peers.append((peer: peerID, value: self.foundPeers.filter { $0.peer == peerID }.first?.value ?? "01"))
                    print("connected")
                }
            }

        case .notConnected:
            DispatchQueue.main.async {
                print("not connected")

                if let index = self.peers.firstIndex(where: { $0.peer == peerID }) {
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

    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}

    func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {
        print("Receiving chat history")
    }

    func session(_: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}
}

extension ConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        // MARK: value 수정

        if !foundPeers.contains(where: { $0.peer == peerID }) {
            if let value = info?.first?.value {
                foundPeers.append((peer: peerID, value: value))
            }
        }

        print(foundPeers)
    }

    func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID)
        if let index = foundPeers.firstIndex(where: { $0.peer == peerID }) {
            foundPeers.remove(at: index)
        }
    }
}
