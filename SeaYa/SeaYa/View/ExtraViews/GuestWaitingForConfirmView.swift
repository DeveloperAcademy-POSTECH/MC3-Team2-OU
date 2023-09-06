//
//  GuestWaitingForConfirmView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct GuestWaitingForConfirmView: View {
    var body: some View {
        ZStack {
            LottieView(jsonName: "rank")
                .frame(width: 360)
                .offset(x: 10, y: -20)

            VStack(alignment: .center) {
                Text("잠시만 기다려주세요")
                    .title(textColor: Color.primaryColor)
                    .fontWeight(.bold)
                    .offset(x: 0, y: 130)

                Text("호스트가 일정을 조율중이예요.")
                    .body(textColor: Color.textColor)
                    .offset(x: 0, y: 145)
            }
        }
    }
}

struct GuestWaitingForConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GuestWaitingForConfirmView()
        GuestWaitingForConfirmView()
            .preferredColorScheme(.dark)
    }
}
