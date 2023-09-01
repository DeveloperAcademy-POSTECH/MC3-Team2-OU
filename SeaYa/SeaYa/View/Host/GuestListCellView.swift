//
//  GuestListCellView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/27.
//

import SwiftUI

struct GuestListCellView: View {
    @EnvironmentObject private var connectionManager: ConnectionService
    @State private var isSelected = Array(repeating: false, count: 6)
    var index: Int

    var body: some View {
        if connectionManager.foundPeers.count <= index {
            Rectangle()
                .opacity(0)
                .frame(width: 75, height: 93)
        } else {
            VStack {
                Button(action: {
                    isSelected[index].toggle()

                    if isSelected[index] {
                        guard let session = connectionManager.session else { return }
                        connectionManager.browser?.invitePeer(
                            connectionManager.foundPeers[index].peer,
                            to: session,
                            withContext: nil,
                            timeout: 10
                        )
                    } else {
                        if let idx = connectionManager.peers.firstIndex(where: {
                            $0.peer == connectionManager.foundPeers[index].peer
                        }) {
                            connectionManager.peers.remove(at: idx)
                        }
                    }
                }, label: {
                    VStack {
                        ZStack {
                            if isSelected[index], connectionManager.peers.contains(where: { $0.peer == connectionManager.foundPeers[index].peer }) {
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(.white)
                            }

                            Image("\(connectionManager.foundPeers[index].value)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }

                        Text(connectionManager.foundPeers[index].peer.displayName)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                })
            }
            .frame(maxWidth: 75, alignment: .center)
        }
    }
}
