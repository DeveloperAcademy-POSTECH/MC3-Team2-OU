//
//  GuestCallingDone.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct GuestCallingDone: View {
    @ObservedObject var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        VStack {
            Text("그룹에 들어왔어요!")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)

            Image("guestCallingDoneImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            Text(connectionManager.groupInfo?.scheduleName ?? "")
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
            Divider()
                .frame(width: 214)
            Text("\(connectionManager.groupInfo?.hostName ?? "")님의 그룹에 초대됐어요.\n지금 바로 일정을 입력하세요!")
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.vertical,30)
            SmallButton_Blue(title: "일정입력하기", action: {})
                .padding(.bottom, 32)
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(32)
        
    }
}

struct GuestCallingDone_Previews: PreviewProvider {
    static var previews: some View {
        GuestCallingDone(connectionManager: ConnectionService())
    }
}
