//
//  ListUpView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/17.
//

import SwiftUI


struct ListUpView: View {
    @State var selected : TimeOks?
    var timeOkGroup : [[TimeOks]]
    var period : Int
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("최종일정을 선택해주세요").title(textColor: .primary)
                    Spacer()
                }.padding(.leading, 16)
                ScrollView{
                    VStack(spacing:16){
                        ForEach(timeOkGroup, id : \.self){ timeOks in
                            ListUpElementView(selected: $selected, timeOks: timeOks, period: period)
                        }
                        Spacer().frame(height: 40)
                    }
                }
                Spacer()
                if let selected = selected{
                    NavigationLink(destination: ConfirmView(
                        selectedEvent: DateEvent(
                            title: "선택받은 이벤트 이름",
                            startDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt*1800)),
                            endDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt*1800))
                        )
                    ), label:  {
                        Text("일정 검토하기").bigButton(textColor: .white)
                            .frame(width: 358, alignment: .center)
                            .padding(.vertical, 18)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                    }).simultaneousGesture(TapGesture().onEnded{
                            let selectedEvent = DateEvent(title: "Default", startDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt*1800)), endDate: Date(timeIntervalSince1970: TimeInterval((selected.timeInt+1)*1800)))
                            let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from:selectedEvent.startDate )
                            print(time.year!, time.month!, time.day!, time.hour!, time.minute!, selected.Oks,time.timeZone!)
                    })
                } else {
                    BigButton_Unactive(title: "최종 일정을 선택해주세요", action: {})
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
        }
    }
}

struct ListUpView_Previews: PreviewProvider {
    static var previews: some View {
        ListUpView(timeOkGroup : [[TimeOks(timeInt: 940614, Oks: 2)],
                                  [TimeOks(timeInt: 940620, Oks: 2),
                                   TimeOks(timeInt: 940621, Oks: 2)],
                                  [TimeOks(timeInt: 940615, Oks: 1),
                                   TimeOks(timeInt: 940616, Oks: 1)],
                                  [TimeOks(timeInt: 940622, Oks: 1),
                                   TimeOks(timeInt: 940623, Oks: 1)],
                                  [TimeOks(timeInt: 940625, Oks: 1),
                                   TimeOks(timeInt: 940626, Oks: 1)]],
        period: 1)
    }
}
