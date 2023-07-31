//
//  GuestWaitingForConfirmView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct GuestWaitingForConfirmView: View {
    var body: some View {
        VStack(alignment: .center){
            Image("result")
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 270, leading: 130, bottom: 40, trailing: 118))
            
            Text("잠시만 기다려주세요")
                .title(textColor: Color.primaryColor)
                .padding(.bottom, 6)
            
            Text("호스트가 일정을 조율중이예요.")
                .body(textColor: Color.textColor)
            
            Spacer(minLength: 0)
        }
    }
}

struct GuestWaitingForConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        GuestWaitingForConfirmView()
    }
}
