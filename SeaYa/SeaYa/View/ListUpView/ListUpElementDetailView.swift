//
//  ListUpElementDetailView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/18.
//

import SwiftUI

struct ListUpElementDetailView: View {
    @Binding var selected: TimeOks?
    @Binding var showDetail: Bool
    @Binding var forGuest: Bool
    var index: Double = 0
    var timeOks: TimeOks
    var period: Int
    var body: some View {
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: Date(timeIntervalSince1970: TimeInterval(timeOks.timeInt * 1800)))
        let endTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval((timeOks.timeInt + period) * 1800)))
        VStack(spacing: 0) {
            Divider().padding(.bottom, 11)
            HStack {
                Text("\(time.hour!):\(String(format: "%02d", time.minute!)) - " +
                    "\(endTime.hour!):\(String(format: "%02d", endTime.minute!))")
                    .font(.system(size: 17))
                    .foregroundColor(Color.primary)
                Spacer()
                if !forGuest {
                    Button {
                        if selected != timeOks {
                            selected = timeOks
                        } else {
                            selected = nil
                        }
                    } label: {
                        if selected == timeOks {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 23.91, height: 23.91)
                        } else {
                            ZStack {
                                Circle()
                                    .strokeBorder(selected == timeOks ? Color.primaryColor : Color.unactiveColor, lineWidth: 1)
                                    .frame(width: 22, height: 22)
                            }.frame(width: 23.91, height: 23.91)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 15))
        }
        .padding(.bottom, 12)
        .offset(y: showDetail ? 0 : -40 * (index + 1))
        .opacity(showDetail ? 1 : 0)
        .animation(Animation
            .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 1),
            value: showDetail)
    }
}

struct ListUpElementDetailTestView: View {
    @State private var selected: TimeOks? = TimeOks(timeInt: 940_625, Oks: 4)
    @State private var showDetail = true
    @State var forGuest = true

    var body: some View {
        VStack {
            Button(String(describing: showDetail)) {
                withAnimation {
                    showDetail.toggle()
                }
            }
            Spacer()
            if showDetail {
                ListUpElementDetailView(selected: $selected, showDetail: $showDetail, forGuest: $forGuest, index: 0, timeOks: TimeOks(timeInt: 940_624, Oks: 3), period: 4)
                ListUpElementDetailView(selected: $selected, showDetail: $showDetail, forGuest: $forGuest, index: 1, timeOks: TimeOks(timeInt: 940_624, Oks: 3), period: 5)
            }
            Spacer()
            Divider()
        }
    }
}

#Preview{
    ListUpElementDetailTestView(forGuest: false)
}
#Preview{
    ListUpElementDetailTestView(forGuest: false)
        .preferredColorScheme(.dark)
}
