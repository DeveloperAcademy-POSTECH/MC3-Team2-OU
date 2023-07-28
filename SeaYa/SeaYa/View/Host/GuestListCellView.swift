//
//  GuestListCellView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/27.
//

import SwiftUI

struct GuestListCellView: View {
    @ObservedObject private var connectionManager = ConnectionService()
    @State private var isSelected = false
    var index: Int
    
    var body: some View {
        if connectionManager.foundPeers.count <= index {
            Rectangle()
                .opacity(0)
                .frame(width: 75, height: 93)
        }
        
        else {
            let foundPeer = connectionManager.foundPeers[index]
            
            VStack {
                Button(action: {
                    isSelected.toggle()
                    
                    if isSelected{
                        guard let session = connectionManager.session else {return}
                        connectionManager.browser?.invitePeer(
                            foundPeer.peer,
                            to: session,
                            withContext: nil,
                            timeout: 10
                        )
                    }
                    else {
                        //TODO: session에서 해제
                    }
                }, label: {
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 65, height: 65)
                                .foregroundColor(.white)
                            
                            Image("\(foundPeer.value)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                        
                        Text(foundPeer.peer.displayName)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                })
            }
            .frame(alignment: .center)
        }
    }
}

struct GuestListCellView_Previews: PreviewProvider {
    static var previews: some View {
        GuestListCellView(index: 0)
    }
}
