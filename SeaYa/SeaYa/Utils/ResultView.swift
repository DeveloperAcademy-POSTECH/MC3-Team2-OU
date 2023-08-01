//
//  ResultView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    @State private var schedule = ScheduleDone()
    @State private var isAttend = false
    
    var body: some View {
        VStack {
            Text(isAttend ? "일정이 성사됐어요!" : "일정이 성사되지 않았어요")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)
                
            Image("your_image_name")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                
            Text(schedule.scheduleName)
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
                
            Divider()
                .frame(width: 214)
                
            Text(schedule.selectedDate.toString())
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.top,30)
                
            Text("\(schedule.startTime.toString()) - \(schedule.endTime.toString())")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 3)
                .padding(.bottom, 29)
            
            if isAttend {
                SmallButton_Blue(title: "일정입력하기", action: {})
                    .padding(.bottom, 10)
                
                SmallButton_White(title: "홈화면으로 돌아가기", action: {})
                    .padding(.bottom, 19)
            }else {
                SmallButton_Blue(title: "홈화면으로 돌아가기", action: {})
                    .padding(.bottom, 19)
            }
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(32)
        .onAppear() {
            schedule = connectionManager.scheduleDone ?? ScheduleDone()
            isAttend = (!connectionManager.isHosting) || (schedule.isAttend[userData.nickname] == true)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(connectionManager: ConnectionService())
    }
}
