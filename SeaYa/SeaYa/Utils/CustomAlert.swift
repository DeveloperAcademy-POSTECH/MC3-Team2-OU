//
//  CustomAlert.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var showingAlert: Bool
    @Binding var moveToDoneView: Bool
    let guestCnt: Int

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.5)
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .foregroundColor(.whiteColor)

                VStack {
                    Text("그룹을 확정하시겠어요?")
                        .headline(textColor: Color.textColor)
                        .padding(.top, 43)

                    Text("\(guestCnt)명의 그룹원과\n그룹을 확정하시겠어요?")
                        .context(textColor: Color.textColor)
                        .padding()
                        .fixedSize()
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)

                    SmallButton_Blue(
                        title: "확정할게요",
                        action: {
                            moveToDoneView = true
                            showingAlert = false
                        }
                    )
                    .padding(.top, 29)

                    SmallButton_White(
                        title: "아니요, 더 찾아볼게요",
                        action: {
                            showingAlert = false
                        }
                    )
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: 300, maxHeight: 260)
        }
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(showingAlert: .constant(true), moveToDoneView: .constant(true), guestCnt: 0)
        CustomAlert(showingAlert: .constant(true), moveToDoneView: .constant(true), guestCnt: 0).preferredColorScheme(.dark)
    }
}
