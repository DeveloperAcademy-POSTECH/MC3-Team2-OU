//
//  WaitingForConfirmView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct WaitingForConfirmView: View {
    var body: some View {
        ZStack {
            LottieView(jsonName: "pencil")
                .frame(width: 350)
                .offset(x: 15, y: -20)

            VStack(alignment: .center) {
                Text("잠시만 기다려주세요")
                    .title(textColor: Color.primaryColor)
                    .fontWeight(.bold)
                    .offset(x: 0, y: 130)

                Text("그룹원이 일정을 입력하고 있어요.")
                    .body(textColor: Color.textColor)
                    .offset(x: 0, y: 145)
            }
        }
    }
}

struct WaitingForConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForConfirmView()
        WaitingForConfirmView()
            .preferredColorScheme(.dark)
    }
}
