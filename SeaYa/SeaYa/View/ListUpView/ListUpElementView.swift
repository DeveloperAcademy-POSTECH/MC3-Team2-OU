//
//  ListUpElementView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/17.
//

import SwiftUI

struct ListUpElementView: View {
    @Binding var selected : TimeOks?
    var timeOks : [TimeOks]
    var period : Int
    @State private var showDetail = false
    var body: some View {
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: Date(timeIntervalSince1970: TimeInterval(timeOks.first!.timeInt*1800)))
        let endTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval((timeOks.last!.timeInt + period)*1800)))
        //Rectangle 10
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(width: 358, height: showDetail ? CGFloat((timeOks.count-1) * 70 + 98) : 98)
            .overlay{
                VStack{
                    Spacer().frame(height: 20)
                    HStack{
                        VStack(alignment: .leading,spacing: 10){
                            Text("\(time.hour!) : \(String(format: "%02d", time.minute!)) - " +
                                 "\(endTime.hour!) : \(String(format: "%02d", endTime.minute!))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)))
                            HStack{
                                Text("\(time.month!)월 " +
                                     "\(time.day!)일" +
                                     "(\(time.weekday.dayOfWeek()))")
                                .font(.system(size: 15, weight: .regular)).tracking(-0.22)
                                //6명
                                Text("\(Image(systemName: "person.2.fill")) \(timeOks.first!.Oks)명").font(.system(size: 13, weight: .bold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0.48, blue: 1, alpha: 1)))}}
                        Spacer()
                        if timeOks.count > 1{
                            Button{
                                withAnimation{showDetail.toggle()}
                            } label : {
                                Text("\(Image(systemName: "chevron.up"))")
                                    .rotationEffect(.degrees(showDetail ? -180 : 0))
                            }
                        } else {
                            Button{
                                if selected != timeOks.first! {
                                    selected = timeOks.first!
                                } else {
                                    selected = nil
                                }
                            } label : {
                                ZStack{
                                    Circle()
                                        .strokeBorder(Color(#colorLiteral(red: 0.7916666865348816, green: 0.7916666865348816, blue: 0.7916666865348816, alpha: 1)), lineWidth: 1)
                                        .frame(width: 22, height: 22)
                                    if selected == timeOks.first! {
                                        Circle()
                                            .fill(Color(#colorLiteral(red: 0, green: 0.47843137383461, blue: 1, alpha: 1)))
                                        .frame(width: 16, height: 16)}}}}}
                    
                    if showDetail && timeOks.count>1{
                        ForEach(timeOks, id : \.self) { ok in
                            ListUpElementDetailView(selected: $selected, timeOks: ok, period: period)
                        }
                    }
                    Spacer()
                }.padding([.leading, .trailing], 30)
            }
    }
}

struct ListUpElementView_Previews: PreviewProvider {
    static var previews: some View {
        
        ListUpElementTestView()
    }
}

struct ListUpElementTestView : View {
    @State private var selected : TimeOks? = nil
    
    var body: some View {
        VStack{
            ScrollView{
                ListUpElementView(selected : $selected,
                                  timeOks:
                                    [TimeOks(timeInt: 940624, Oks: 2)], period: 1)
                
                ListUpElementView(selected : $selected,
                                  timeOks:
                                    [TimeOks(timeInt: 940624, Oks: 5),
                                     TimeOks(timeInt: 940625, Oks: 5),
                                     TimeOks(timeInt: 940626, Oks: 5)], period: 1)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}
