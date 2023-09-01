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
                .foregroundColor(.black)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            ResultCardView()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(ConnectionService())
    }
}
