//
//  ConfirmDateModalView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/21.
//

import SwiftUI

struct ConfirmDateModalView: View {
    @Binding var selectedEvent : DateEvent
    @State private var selectedButtons: [(week: Int, day: Int)] = []
    
    private let weekdays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    private let currentDate = Date()
    private var nextDate: Date {
        return Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
    
    private var firstDayOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }
    
    private var currentWeekIndex: Int {
        let weekOfMonth = calendar.component(.weekOfMonth, from: currentDate)
        return weekOfMonth-1
    }
    
    private func daysBetweenDates(fromDate: Date, toDate: Date) -> (Int?, Int?) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.weekday, .day], from: fromDate, to: toDate)
        return (dateComponents.weekday, dateComponents.day)
    }
    
    private func getWeekdayAndWeekOfMonth(for date: Date) -> (Int, Int)? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .weekOfMonth], from: date)
        
        if let weekday = components.weekday, let weekOfMonth = components.weekOfMonth {
            if weekday-1 == 0{
                return (weekOfMonth - 2, 7)
            }
                return (weekOfMonth - 1, weekday - 1)
        } else {
            return nil
        }
    }
    
    private func getDateFromCalendar(_ week : Int, _ day : Int) -> Date {
        let firstWeekDay = Calendar.current.dateComponents([.weekday], from: firstDayOfMonth)
        let theDate = Date(timeInterval: TimeInterval(week*60*60*24*7 + (day+1-firstWeekDay.weekday!)*60*60*24), since: firstDayOfMonth)
        return theDate
    }
        
    var body: some View {
        VStack(spacing: 0){
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(hex: "#D3D3D3"))
                .frame(width:34, height:5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 26, trailing: 0))
            Text("날짜").headline(textColor: .primaryColor).padding(.bottom, 43)
            VStack {
                HStack {
                    ForEach(weekdays, id: \.self) { (weekday) in
                        Text(weekday)
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                }
                VStack {
                    ForEach(currentWeekIndex..<currentWeekIndex+3, id: \.self) { week in
                        HStack {
                            ForEach(1...7, id: \.self) { day in
                                let date = dayText(week: week, day: day)
                                let isSelected = isSelected(week: week, day: day)
                                if date > currentDate && date < nextDate{
                                    Button(action: {
                                        toggleButtonSelection(week: week, day: day)
                                        let newData = Calendar.current.dateComponents([.year, .month, .day], from : getDateFromCalendar(week, day))
                                        let prevStartData = Calendar.current.dateComponents([.hour, .minute], from: selectedEvent.startDate)
                                        let prevEndData = Calendar.current.dateComponents([.hour, .minute], from: selectedEvent.endDate)
                                        selectedEvent.startDate = DateUtil.formattedDateToDate(newData.year, newData.month, newData.day, prevStartData.hour, prevStartData.minute)
                                        selectedEvent.endDate = DateUtil.formattedDateToDate(newData.year, newData.month, newData.day, prevEndData.hour, prevEndData.minute)
                                    }, label: {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(isSelected || currentDate == date ? Color.blue : Color.clear
                                                )
                                            Text(date.toStringg())
                                                .frame(maxWidth: .infinity)
                                                .padding(8)
                                                .foregroundColor(isSelected ? .white : ( day == 7 ?  .red : .black ))
                                        }
                                    })
                                } else {
                                    Text(date.toStringg())
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }.onAppear{
                    selectedButtons.append(getWeekdayAndWeekOfMonth(for: selectedEvent.startDate)!)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 60, trailing: 30))
    }
    
    func toggleButtonSelection(week: Int, day: Int) {
           let button = (week, day)
           if selectedButtons.count == 1{
               let _ = selectedButtons.popLast()
               selectedButtons.append(button)
           } else if selectedButtons.count == 0{
               selectedButtons.append(button)
           }
       }

       func isSelected(week: Int, day: Int) -> Bool {
           return selectedButtons.contains { $0 == (week, day) }
       }
    
    func dayText(week: Int, day: Int) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        dateComponents.day! += ((week * 7) + day - calendar.component(.weekday, from: firstDayOfMonth) + 2)
        return calendar.date(from: dateComponents)!
    }
    
    
}

struct ConfirmDateModalView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmDateModalTestView()
    }
}

struct ConfirmDateModalTestView : View{
    @State private var isModalPresented = true
    @State private var selectedEvent = DateEvent(
        title: "Test Event",
        startDate: Date(timeIntervalSinceNow: 60*60*24*2),
        endDate: Date(timeIntervalSinceNow: 60*60*24*2 + 60*30)
        )
    var body: some View{
        VStack{
            Text(String(describing: selectedEvent.startDate))
            Text(String(describing: selectedEvent.endDate))
            Button("Show Modal"){
                isModalPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isModalPresented, content: {
            ConfirmDateModalView(selectedEvent: $selectedEvent)
                .presentationDetents([.height(354)])
                .presentationCornerRadius(32)
        })
    }
}
