//
//  Card1View.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/17.
//

import SwiftUI

struct HostCallingDone: View {
    @State var clicked: Int? = 0
    @EnvironmentObject private var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    var groupInfo: GroupInfo
    var body: some View {
        VStack {
            Text("그룹이 확정되었어요")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)
            Image("guestCallingDoneImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            Text(groupInfo.scheduleName)
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
            Divider()
                .frame(width: 214)
            Text("그룹이 생성되었어요. \n지금 바로 일정을 입력하세요!")
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.vertical, 30)
            NavigationLink(
                destination: TimeTable(
                    vm: TimeTableViewModel.shared
                )
                .navigationBarBackButtonHidden(true)
                .environmentObject(userData)
                .onAppear{
                    TimeTableViewModel.shared.setSelectedDay(selectedDay: getSelectedDate(groupInfo))
                    connectionManager.setGroupInfo(groupInfo)
                },
                label: {
                    Text("일정 입력하기")
                        .smallButton(textColor: .white)
                        .padding(.vertical, 18)
                        .frame(width: 268, height: 45, alignment: .center)
                        .background(Color.primaryColor)
                        .cornerRadius(16)
                })
            .padding(.bottom, 32)
        }
        .frame(width: 300)
        .background(Color.whiteColor)
        .cornerRadius(32)
    }

    func getSelectedDate(_ groupInfo: GroupInfo) -> [String] {
        return groupInfo.selectedDate.map { date in
            DateUtil.getFormattedDate(date)
        }
    }
}

#Preview{
    NavigationStack{
        ZStack{
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            HostCallingDone(
                groupInfo: GroupInfo.empty()
            )
        }
        .environmentObject(ConnectionService())
        .environmentObject(UserData())
    }
}
#Preview{
    NavigationStack{
        ZStack{
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            HostCallingDone(
                groupInfo: GroupInfo.empty()
            )
        }
        .environmentObject(ConnectionService())
        .environmentObject(UserData())
        .preferredColorScheme(.dark)
    }
}
