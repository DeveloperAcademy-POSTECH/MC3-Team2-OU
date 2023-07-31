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
    
    @State private var scheduleName: String = ""
    @State private var selectedDate: String = ""
    @State private var startTime: String = ""
    @State private var endTime: String = ""
    @State private var isAttend: Bool = false
    
    var body: some View {
        VStack {
            Text(isAttend ? "일정이 성사됐어요!" : "일정이 성사되지 않았어요")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)
                
            Image("your_image_name")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                
            Text(scheduleName)
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
                
            Divider()
                .frame(width: 214)
                
            Text(selectedDate)
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.top,30)
                
            Text("\(startTime) - \(endTime)")
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
            guard let schedule = connectionManager.scheduleDone else {return}
            scheduleName = schedule.scheduleName
            selectedDate = schedule.selectedDate.toString()
            startTime = schedule.startTime.toString()
            endTime = schedule.endTime.toString()
            isAttend = schedule.isAttend[userData.nickname] ?? false
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(connectionManager: ConnectionService())
    }
}
