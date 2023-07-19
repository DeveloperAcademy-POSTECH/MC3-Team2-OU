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
        VStack{
            Divider()
            HStack{
                Text("\(time.hour!) : \(String(format: "%02d", time.minute!)) - " +
                     "\(endTime.hour!) : \(String(format: "%02d", endTime.minute!))")
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)))
                Spacer()
                Button{
                    if selected != timeOks{
                        selected = timeOks
                    } else {
                        selected = nil
                    }
                } label : {
                    ZStack{
                        Circle()
                            .strokeBorder(Color(#colorLiteral(red: 0.7916666865348816, green: 0.7916666865348816, blue: 0.7916666865348816, alpha: 1)), lineWidth: 1)
                            .frame(width: 22, height: 22)
                        if selected == timeOks {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0, green: 0.47843137383461, blue: 1, alpha: 1)))
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
        }
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
