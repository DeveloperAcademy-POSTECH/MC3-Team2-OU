//
//  ResultView.swift
//  SeaYa
//
//  Created by hyebin on 2023/08/01.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var connectionManager: ConnectionService

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            ResultCardView()
        }
    }
}

#Preview{
    ResultView()
        .environmentObject(ConnectionService())
}
#Preview{
    ResultView()
        .environmentObject(ConnectionService())
        .preferredColorScheme(.dark)
}
