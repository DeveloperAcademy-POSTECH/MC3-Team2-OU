//
//  ListUpElementDetailView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/18.
//

import SwiftUI

struct ListUpElementDetailView: View {
    @Binding var selected : TimeOks?
    var timeOks : TimeOks
    var period : Int
    var body: some View {
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: Date(timeIntervalSince1970: TimeInterval(timeOks.timeInt*1800)))
        let endTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval((timeOks.timeInt + period)*1800)))
        VStack(spacing:0){
            Divider().padding(.bottom, 11)
            HStack{
                Text("\(time.hour!):\(String(format: "%02d", time.minute!)) - " +
                     "\(endTime.hour!):\(String(format: "%02d", endTime.minute!))")
                .font(.system(size: 17))
                .foregroundColor(Color.primary)
                Spacer()
                Button{
                    if selected != timeOks{
                        selected = timeOks
                    } else {
                        selected = nil
                    }
                } label : {
                        if selected == timeOks {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 23.91, height: 23.91)
                        }
                        else {
                            ZStack{
                                Circle()
                                    .strokeBorder(selected == timeOks ? Color.primaryColor : Color.unactiveColor , lineWidth: 1)
                                    .frame(width: 22, height: 22)
                            }.frame(width: 23.91, height: 23.91)
                        }
                }
            }
            .frame(height: 23)
            .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing:15))
        }
        .padding(.bottom, 12)
    }
}

struct ListUpElementDetailTestView:View{
    @State private var selected : TimeOks? = TimeOks(timeInt: 940625, Oks: 4)
    
    var body: some View{
        VStack{
            Spacer()
            ListUpElementDetailView(selected: $selected, timeOks: TimeOks(timeInt: 940624, Oks: 3), period: 4)
            Spacer()
            Divider()
        }
    }
}

struct ListUpElementDetailTestView_Previews: PreviewProvider {
    static var previews: some View {
        ListUpElementDetailTestView()
    }
}
