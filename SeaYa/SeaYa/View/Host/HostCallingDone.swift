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
                    vm: TimeTableViewModel.shared)
                    .navigationBarBackButtonHidden(true),
                tag: 1,
                selection: $clicked
            ) {}
            SmallButton_Blue(title: "일정 입력하기", action: {
                TimeTableViewModel.shared.setSelectedDay(selectedDay: getSelectedDate(groupInfo))
                connectionManager.setGroupInfo(groupInfo)
                clicked = 1
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

struct HostCallingDone_Previews: PreviewProvider {
    static var previews: some View {
        HostCallingDone(
            groupInfo: GroupInfo.empty()
        ).environmentObject(UserData())
        HostCallingDone(
            groupInfo: GroupInfo.empty()
        ).environmentObject(UserData())
            .preferredColorScheme(.dark)
    }
}
