//
//  GuestListView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/27.
//

import SwiftUI

struct GuestListView: View {
    @ObservedObject var connectionManager: ConnectionService
    
    var body: some View {
        HStack {
            VStack {
                GuestListCellView(connectionManager: connectionManager, index: 3)
                    .padding(.bottom, 57)
                
                GuestListCellView(connectionManager: connectionManager, index: 1)
            }
            
            VStack {
                GuestListCellView(connectionManager: connectionManager, index: 5)
                    .padding(.bottom, 57)
                
                GuestListCellView(connectionManager: connectionManager, index: 0)
            }
            .padding(.horizontal, 60)
            .offset(y: -70)
            
            VStack {
                GuestListCellView(connectionManager: connectionManager, index: 4)
                    .padding(.bottom, 57)
                
                GuestListCellView(connectionManager: connectionManager, index: 2)
            }
        }
    }
}
