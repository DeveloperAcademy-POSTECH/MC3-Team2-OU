//
//  GuestListView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/27.
//

import SwiftUI

struct GuestListView: View {
    @EnvironmentObject private var connectionManager: ConnectionService

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                GuestListCellView(index: 3)
                    .padding(.bottom, 57)

                GuestListCellView(index: 1)
            }

            VStack {
                GuestListCellView(index: 5)
                    .padding(.bottom, 57)

                GuestListCellView(index: 0)
            }
            .padding(.horizontal, 60)
            .offset(y: -70)

            VStack {
                GuestListCellView(index: 4)
                    .padding(.bottom, 57)

                GuestListCellView(index: 2)
            }
        }
    }
}
