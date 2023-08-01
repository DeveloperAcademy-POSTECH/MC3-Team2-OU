//
//  WaitingForConfirmView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct WaitingForConfirmView: View {
    var body: some View {
        VStack(alignment: .center){
            Image("guestCallingDoneImage")
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 270, leading: 130, bottom: 40, trailing: 118))
            
            Text("잠시만 기다려주세요")
                .title(textColor: Color.primaryColor)
                .padding(.bottom, 6)
            
            Text("그룹원이 일정을 입력하고 있어요")
                .body(textColor: Color.textColor)
            
            Spacer(minLength: 0)
        }
    }
}

struct WaitingForConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForConfirmView()
    }
}
