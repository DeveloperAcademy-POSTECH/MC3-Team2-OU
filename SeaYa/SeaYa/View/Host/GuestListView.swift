//
//  GuestListView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/27.
//

import SwiftUI

struct GuestListView: View {
    var body: some View {
        HStack {
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

struct GuestListView_Previews: PreviewProvider {
    static var previews: some View {
        GuestListView()
    }
}
