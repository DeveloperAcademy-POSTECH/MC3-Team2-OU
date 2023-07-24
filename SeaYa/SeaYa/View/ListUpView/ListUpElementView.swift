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
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
            VStack{
                HStack{
                    VStack(alignment: .leading,spacing: 6){
                        Text("\(time.hour!):\(String(format: "%02d", time.minute!)) - " +
                             "\(endTime.hour!):\(String(format: "%02d", endTime.minute!))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.black)
                        HStack{
                            Text("\(time.month!)월 " +
                                 "\(time.day!)일" +
                                 " (\(time.weekday.dayOfWeek()))")
                            .font(.system(size: 15, weight: .regular)).tracking(-0.22)
                            //6명
                            Text("\(Image(systemName: "person.2.fill")) \(timeOks.first!.Oks)명").font(.system(size: 13, weight: .bold)).foregroundColor(Color.primaryColor)}}
                    Spacer()
                    if timeOks.count > 1{
                        Button{
                            withAnimation{showDetail.toggle()}
                        } label : {
                            Text("\(Image(systemName: "chevron.up"))")
                                .rotationEffect(.degrees(showDetail ? -180 : 0))
                                .foregroundColor(Color.primary)
                        }
                    } else {
                        Button{
                            if selected != timeOks.first! {
                                selected = timeOks.first!
                            } else {
                                selected = nil
                            }
                        } label : {
                            if selected == timeOks.first! {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 23.91, height: 23.91)
                            }
                            else {
                                ZStack{
                                    Circle()
                                        .strokeBorder(selected == timeOks.first! ? Color.primaryColor : Color.unactiveColor , lineWidth: 1)
                                        .frame(width: 22, height: 22)
                                }.frame(width: 23.91, height: 23.91)
                            }
                        }}}
                    .padding(EdgeInsets(top: 25, leading: 18, bottom: 21, trailing: 20))
                if showDetail && timeOks.count>1{
                    VStack(spacing: 0){
                        ForEach(timeOks, id : \.self) { ok in
                            ListUpElementDetailView(selected: $selected, timeOks: ok, period: period)
                        }
                    }.padding(.leading, 18)
                }
            }
        }.padding([.leading, .trailing], 16)
        
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
                                     TimeOks(timeInt: 940627, Oks: 5),
                                     TimeOks(timeInt: 940628, Oks: 5),
                                     TimeOks(timeInt: 940629, Oks: 5)], period: 1)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}
