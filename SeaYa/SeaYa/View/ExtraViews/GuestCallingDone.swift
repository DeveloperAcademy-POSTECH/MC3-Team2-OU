//
//  GuestCallingDone.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct GuestCallingDone: View {
    @EnvironmentObject private var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    @State var clicked: Int? = 0
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
                .padding(.vertical, 30)
            .padding(.bottom, 32)
            NavigationLink(destination:
                            TimeTable(
                                vm: TimeTableViewModel.shared)
                                .navigationBarBackButtonHidden(true)
                                .onAppear{
                                    TimeTableViewModel.shared.setSelectedDay(
                                        selectedDay: getSelectedDate(connectionManager.groupInfo ?? GroupInfo.empty()))
                                },
                           label: {
                            Text("일정 입력하기")
                            .smallButton(textColor: .white)
                                .frame(width: 268, height: 45, alignment: .center)
                                .background(Color.primaryColor)
                                .cornerRadius(16)
                                .padding(.vertical, 18)
                }
            )
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

struct GuestCallingDone_Previews: PreviewProvider {
    static var previews: some View {
        GuestCallingDone()
            .environmentObject(ConnectionService())
            .environmentObject(UserData())
        GuestCallingDone()
            .environmentObject(ConnectionService())
            .environmentObject(UserData())
            .preferredColorScheme(.dark)
    }
}
