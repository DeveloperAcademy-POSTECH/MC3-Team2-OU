//
//  ListUpView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/17.
//

import SwiftUI

struct ListUpView: View {
    @EnvironmentObject private var connectionManager: ConnectionService
    @State var selected: TimeOks?
    @State var forGuest: Bool = false
    var timeOkGroup: [[TimeOks]]
    var period: Int
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(forGuest ? "최종일정 후보를 확인해주세요" : "최종일정을 선택해주세요").title(textColor: .primary)
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 50)
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(timeOkGroup, id: \.self) { timeOks in
                            if timeOks.count > 0 {
                                ListUpElementView(selected: $selected, forGuest: $forGuest, timeOks: timeOks, period: period)
                            }
                        }
                        Spacer().frame(height: 40)
                    }
                }
                Spacer()
                if !forGuest {
                    if let selected = selected {
                        NavigationLink(
                            destination: ConfirmView(
                                selectedEvent: DateEvent(
                                    title: connectionManager.groupInfo?.scheduleName ?? "우리들의 모임",
                                    startDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt * 1800)),
                                    endDate: Date(timeIntervalSince1970: TimeInterval((selected.timeInt + period) * 1800))
                                )
                            ), label: {
                                Text("일정 검토하기").bigButton(textColor: .white)
                                    .frame(width: 358, alignment: .center)
                                    .padding(.vertical, 18)
                                    .background(Color.primaryColor)
                                    .cornerRadius(16)
                            }
                        )
                        .simultaneousGesture(TapGesture().onEnded {
                            let selectedEvent = DateEvent(title: "Default", startDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt * 1800)), endDate: Date(timeIntervalSince1970: TimeInterval((selected.timeInt + 1) * 1800)))
                            let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: selectedEvent.startDate)
                            print(time.year!, time.month!, time.day!, time.hour!, time.minute!, selected.Oks, time.timeZone!)
                        }
                        )
                    } else {
                        BigButton_Unactive(title: "최종 일정을 선택해주세요", action: {})
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    print("Peers \(connectionManager.peers)")
                    connectionManager.send(true, messageType: .CheckTimeDone)
                }
                .background(Color.backgroundColor)
        }
    }
}

struct ListUpView_Previews: PreviewProvider {
    static var previews: some View {
        ListUpView(
            forGuest: false,
            timeOkGroup: [[TimeOks(timeInt: 940_614, Oks: 2)],
                          [TimeOks(timeInt: 940_620, Oks: 2),
                           TimeOks(timeInt: 940_621, Oks: 2)],
                          [TimeOks(timeInt: 940_615, Oks: 1),
                           TimeOks(timeInt: 940_616, Oks: 1)],
                          [TimeOks(timeInt: 940_622, Oks: 1),
                           TimeOks(timeInt: 940_623, Oks: 1)],
                          [TimeOks(timeInt: 940_625, Oks: 1),
                           TimeOks(timeInt: 940_626, Oks: 1)]],
            period: 1
        )
        ListUpView(
            forGuest: false,
            timeOkGroup: [[TimeOks(timeInt: 940_614, Oks: 2)],
                          [TimeOks(timeInt: 940_620, Oks: 2),
                           TimeOks(timeInt: 940_621, Oks: 2)],
                          [TimeOks(timeInt: 940_615, Oks: 1),
                           TimeOks(timeInt: 940_616, Oks: 1)],
                          [TimeOks(timeInt: 940_622, Oks: 1),
                           TimeOks(timeInt: 940_623, Oks: 1)],
                          [TimeOks(timeInt: 940_625, Oks: 1),
                           TimeOks(timeInt: 940_626, Oks: 1)]],
            period: 1
        )
        .preferredColorScheme(.dark)
    }
}
