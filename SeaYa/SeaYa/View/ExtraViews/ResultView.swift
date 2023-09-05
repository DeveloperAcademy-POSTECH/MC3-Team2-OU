//
//  ResultView.swift
//  SeaYa
//
//  Created by hyebin on 2023/08/01.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var connectionManager: ConnectionService
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            ResultCardView(connectionManager: connectionManager)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(connectionManager: ConnectionService())
    }
}
