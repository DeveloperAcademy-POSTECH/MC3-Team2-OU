//
//  ListUpElementView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/17.
//

import SwiftUI

struct ListUpElementView: View {
    @Binding var selected: TimeOks?
    @Binding var forGuest: Bool
    var timeOks: [TimeOks]
    var period: Int
    @State private var showDetail = false
    var body: some View {
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: Date(timeIntervalSince1970: TimeInterval(timeOks.first!.timeInt * 1800)))
        let endTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval((timeOks.last!.timeInt + period) * 1800)))
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.whiteColor)
                .animation(Animation
                    .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 1),
                    value: showDetail)
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(time.hour!):\(String(format: "%02d", time.minute!)) - " +
                            "\(endTime.hour!):\(String(format: "%02d", endTime.minute!))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.primary)
                        HStack {
                            Text("\(time.month!)월 " +
                                "\(time.day!)일" +
                                " (\(time.weekday.dayOfWeek()))")
                                .font(.system(size: 15, weight: .regular)).tracking(-0.22)
                            // 6명
                            Text("\(Image(systemName: "person.2.fill")) \(timeOks.first!.Oks)명").font(.system(size: 13, weight: .bold)).foregroundColor(Color.primaryColor)
                        }
                    }
                    Spacer()

                    if timeOks.count > 1 {
                        Button {
                            withAnimation { showDetail.toggle() }
                        } label: {
                            Text("\(Image(systemName: "chevron.down"))")
                                .rotationEffect(.degrees(showDetail ? -180 : 0))
                                .foregroundColor(Color.primary)
                        }
                    } else {
                        if !forGuest {
                            Button(
                                action: {
                                    if selected != timeOks.first! {
                                        selected = timeOks.first!
                                    } else {
                                        selected = nil
                                    }
                                },
                                label: {
                                    if selected == timeOks.first! {
                                        Image(systemName: "checkmark.circle.fill")
                                            .resizable()
                                            .frame(width: 23.91, height: 23.91)
                                    } else {
                                        ZStack {
                                            Circle()
                                                .strokeBorder(selected == timeOks.first! ? Color.primaryColor : Color.unactiveColor, lineWidth: 1)
                                                .frame(width: 22, height: 22)
                                        }
                                        .frame(width: 23.91, height: 23.91)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(EdgeInsets(top: 25, leading: 18, bottom: 21, trailing: 20))
                if showDetail && timeOks.count > 1 {
                    VStack(spacing: 0) {
                        ForEach(Array(timeOks.enumerated()), id: \.offset) { index, ok in
                            ListUpElementDetailView(selected: $selected, showDetail: $showDetail, forGuest: $forGuest, index: Double(index), timeOks: ok, period: period)
                        }
                    }.padding(.leading, 18)
                }
            }
        }.padding([.leading, .trailing], 16)
    }
}



struct ListUpElementTestView: View {
    @State private var selected: TimeOks? = nil
    @State var forGuest = true

    var body: some View {
        VStack {
            ScrollView {
                ListUpElementView(selected: $selected, forGuest: $forGuest,
                                  timeOks:
                                  [TimeOks(timeInt: 940_624, Oks: 2)], period: 1)
                ListUpElementView(selected: $selected, forGuest: $forGuest,
                                  timeOks:
                                  [TimeOks(timeInt: 940_624, Oks: 5),
                                   TimeOks(timeInt: 940_625, Oks: 5),
                                   TimeOks(timeInt: 940_627, Oks: 5),
                                   TimeOks(timeInt: 940_628, Oks: 5),
                                   TimeOks(timeInt: 940_629, Oks: 5)], period: 1)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.primary)
    }
}

#Preview{
    ListUpElementTestView(forGuest: false)
}
#Preview{
    ListUpElementTestView(forGuest: false)
        .preferredColorScheme(.dark)
}
