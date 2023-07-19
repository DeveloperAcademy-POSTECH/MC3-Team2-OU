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
    var body: some View {
        VStack{
            HStack{
                Text("최종 일정을 선택해주세요").font(.system(size: 23, weight: .bold)).tracking(-0.58)
                Spacer()
            }.padding(20)
            ScrollView{
                ForEach(timeOkGroup, id : \.self){ timeOks in
                    ListUpElementView(selected: $selected, timeOks: timeOks, period: 1)
                }
            }
            Spacer()
            Button(action: {
                if let selected = selected{
                    let selectedEvent = DateEvent(title: "Default", startDate: Date(timeIntervalSince1970: TimeInterval(selected.timeInt*1800)), endDate: Date(timeIntervalSince1970: TimeInterval((selected.timeInt+1)*1800)))
                    print("\(selectedEvent)")
                    let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from:selectedEvent.startDate )
                    print(time.year!, time.month!, time.day!, time.hour!, time.minute!, selected.Oks,time.timeZone!)
                } else {
                    print("아직 선택하지 않았습니다.")
                }
            }, label: {
                Text("다음")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 358)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
    }
}

struct ListUpView_Previews: PreviewProvider {
    static var previews: some View {
        ListUpView(timeOkGroup : [[TimeOks(timeInt: 940614, Oks: 2)], [TimeOks(timeInt: 940620, Oks: 2), TimeOks(timeInt: 940621, Oks: 2)], [TimeOks(timeInt: 940615, Oks: 1), TimeOks(timeInt: 940616, Oks: 1)], [TimeOks(timeInt: 940622, Oks: 1), TimeOks(timeInt: 940623, Oks: 1)], [TimeOks(timeInt: 940625, Oks: 1), TimeOks(timeInt: 940626, Oks: 1)]])
    }
}
