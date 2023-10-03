//
//  ResultCardView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct ResultCardView: View {
    @EnvironmentObject private var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    @State private var schedule = ScheduleDone()
    @State private var isAttend = false
    @State private var moveToMainView = false

    var body: some View {
        VStack {
            Text(isAttend ? "일정이 성사됐어요!" : "일정이 성사되지 않았어요")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)

            Image(isAttend ? "result" : "resultno")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)

            Text(schedule.scheduleName)
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)

            Divider()
                .frame(width: 214)

            if isAttend {
                Text(schedule.selectedDate.toStringDate())
                    .context(textColor: Color.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 25)

                Text("\(DateUtil.getFormattedTime(schedule.startTime)) - \(DateUtil.getFormattedTime(schedule.endTime))")
                    .subtitle(textColor: Color.textColor)
                    .padding(.top, 3)
                    .padding(.bottom, 29)

                ResultToMainView(title: "내 캘린더에 추가하기", action: {
                    registerEvent()
                })
                .padding(.bottom, 10)
                ResultToMainView(title: "홈으로 돌아가기", color: .primaryColor)
                    .padding(.bottom, 19)

            } else {
                Text("최적의 일정을 찾지 못했어요\n아쉽지만 다음에 만나요!")
                    .context(textColor: Color.textColor)
                    .padding(.vertical, 30)

                ResultToMainView(title: "홈화면으로 돌아가기")
                    .padding(.bottom, 32)
            }
        }
        .frame(width: 300)
        .background(Color.whiteColor)
        .cornerRadius(32)
        .onAppear {
            schedule = connectionManager.scheduleDone ?? ScheduleDone()
            isAttend = (!connectionManager.isHosting) || (schedule.isAttend[userData.uid] == true)
        }
    }
}

extension ResultCardView {
    func registerEvent() {
        let event = Event(title: schedule.scheduleName, start: schedule.startTime, end: schedule.endTime)
        Task {
            _ = try await RemoteCalendarRepository.shared.createEvent(event: event)
        }
    }
}

struct ResultToMainView: View {
    var title: String
    var action: () -> Void = {}
    var color: Color = .whiteColor
    var body: some View {
        NavigationLink(
            destination: MainView()
                .onAppear {
                    action()
                }
                .navigationBarBackButtonHidden(),
            label: {
                Text(title)
                    .smallButton(textColor: color == .whiteColor ? .white : .primaryColor)
                    .padding(.vertical, 18)
                    .frame(width: 268, height: 45, alignment: .center)
                    .background(color == .whiteColor ? Color.primaryColor : Color.whiteColor)
                    .cornerRadius(16)
            }
        )
    }
}

#Preview{
    ResultView()
        .environmentObject(ConnectionService())
}
#Preview{
    ResultView()
        .environmentObject(ConnectionService())
        .preferredColorScheme(.dark)
}
