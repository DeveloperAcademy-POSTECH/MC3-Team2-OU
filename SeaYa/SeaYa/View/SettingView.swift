//
//  SettingView.swift
//  SeaYa
//
//  Created by xnoag on 2023/07/17.
//

import SwiftUI
import UIKit

struct SettingView: View {
    
    @State private var startAngle: Double = 0
    @State private var toAngle: Double = 90
    @State private var startProgress: CGFloat = 0
    @State private var toProgress: CGFloat = 0.25
    @State private var selectedWeekdays: Array<String> = ["월"]
    private let weekdays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    @State private var selectedCategories: Array<String> = ["취침"]
    private let categories: [String] = ["취침", "직장", "학교", "공부", "기타"]
    
    var body: some View {
        List() {
            // Section1 - 태그/입력으로 일정을 선택.
            Section(header: Text("일정 설정")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(selectedCategories.contains(category) ? Color.blue : Color.clear)
                                Text(category)
                                    .frame(maxWidth: .infinity)
                                    .font(.headline)
                                    .foregroundColor(selectedCategories.contains(category) ? .white : .black)
                            }
                            .onTapGesture {
                                if selectedCategories.contains(category) {
                                    selectedCategories.remove(at: selectedCategories.firstIndex(of: category) ?? 0)
                                }
                                else if selectedCategories.count > 0 {
                                    selectedCategories.removeAll()
                                    selectedCategories.append(category)
                                } else if selectedCategories.count == 0 {
                                    selectedCategories.append(category)
                                }
                                haptics(.success)
                                print(selectedCategories)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            // Section2 - 반복 요일 선택, 복수 선택 가능.
            Section(header: Text("요일 설정")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)) {
                    HStack {
                        ForEach(weekdays, id: \.self) { weekday in
                            ZStack {
                                Circle()
                                    .foregroundColor(selectedWeekdays.contains(weekday) ? Color.blue : Color.clear)
                                Text(weekday)
                                    .frame(maxWidth: .infinity)
                                    .font(.headline)
                                    .foregroundColor(selectedWeekdays.contains(weekday) ? .white : .black)
                            }
                            .onTapGesture {
                                if selectedWeekdays.contains(weekday) {
                                    //                                    selectedWeekdays.remove
                                    selectedWeekdays.remove(at: selectedWeekdays.firstIndex(of: weekday) ?? 0)
                                } else {
                                    selectedWeekdays.append(weekday)
                                }
                                haptics(.success)
                                print(selectedWeekdays)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            // Section3 - 시작/종료시간 설정.
            Section(header: Text("시간 설정")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)) {
                    VStack {
                        HStack(spacing: 25) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label {
                                    Text("Start")
                                        .foregroundColor(.black)
                                } icon: {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                }
                                .font(.callout)
                                Text(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))
                                    .font(.title2.bold())
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            VStack(alignment: .leading, spacing: 8) {
                                Label {
                                    Text("Finish")
                                        .foregroundColor(.black)
                                } icon: {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.blue)
                                }
                                .font(.callout)
                                Text(getTime(angle: toAngle).formatted(date: .omitted, time: .shortened))
                                    .font(.title2.bold())
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding()
                        .padding(.bottom, 25)
                        SleepTimeSlider()
                            .padding(.bottom, 30)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding()
                }
        }
    }

    @ViewBuilder
    func SleepTimeSlider() -> some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            
            ZStack {
                ZStack {
                    ForEach(1...120, id: \.self) { index in
                        Rectangle()
                            .fill(index % 10 == 0 ? .black : .gray)
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 3))
                    }
                    
                    let texts = [12,18,0,6]
                    
                    ForEach(texts.indices, id: \.self) { index in
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 90))
                    }
                }
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 50)
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                    .stroke(.blue, style: StrokeStyle(lineWidth: 45, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value, fromSlider: true)
                                haptics(.warning)
                                print(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                Image(systemName: "circle.fill")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value, fromSlider: false)
                                haptics(.warning)
                                print(getTime(angle: toAngle).formatted(date: .omitted, time: .shortened))
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                VStack(spacing: 6) {
                    Text("\(getTimeDifference().0)hr")
                        .font(.largeTitle.bold())
                    Text("\(getTimeDifference().1)min")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 {
            angle = 360 + angle
        }
        let progress = angle / 360
        if fromSlider {
            self.startAngle = angle
            self.startProgress = progress
        } else {
            self.toAngle = angle
            self.toProgress = progress
        }
    }
    func getTime(angle: Double) -> Date {
        let progress = angle / 15
        let hour = Int(progress)
        var minute = (progress.truncatingRemainder(dividingBy: 1) * 60).rounded()
        if minute < 61 && minute > 0 {
            minute = 30
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: "\(hour):\(Int(minute))") {
            return date
        }
        return .init()
    }
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = getTime(angle: startAngle)
        let finishDate = getTime(angle: toAngle)
        let adjustedFinishDate: Date
        if finishDate < startDate {
            adjustedFinishDate = calendar.date(byAdding: .day, value: 1, to: finishDate)!
        } else {
            adjustedFinishDate = finishDate
        }
        let result = calendar.dateComponents([.hour, .minute], from: startDate, to: adjustedFinishDate)
        let hour = result.hour ?? 0
        let minute = result.minute ?? 0
        return (hour, minute)
    
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

extension View {
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

