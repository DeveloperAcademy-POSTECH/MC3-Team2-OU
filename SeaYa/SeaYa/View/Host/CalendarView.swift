//
//  CalendarView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: [Date]
    
    var isMultiDatesAvailable = true
    
    private let weekdays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    
    private var currentDate: Date {
        Calendar.current.startOfDay(for: Date())
    }

    private var nextDate: Date {
        return Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.firstWeekday = 2
        return calendar
    }
    
    private var firstDayOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }
    
    private var currentWeekIndex: Int {
        let weekOfMonth = calendar.component(.weekOfMonth, from: currentDate)
        return weekOfMonth - 1
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(weekdays, id: \.self) { (weekday) in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(currentWeekIndex..<currentWeekIndex + 3, id: \.self) { week in
                    HStack {
                        ForEach(1...7, id: \.self) { day in
                            let date = dayText(week: week, day: day)
                            let isSelected = selectedDate.contains(date)
                            
                            if date >= currentDate && date < nextDate {
                                Button(action: {
                                    if isMultiDatesAvailable {
                                        toggleButtonSelection(date: date)
                                    } else {
                                        ButtonSelection(date: date)
                                    }
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(isSelected ? Color.primaryColor : Color.clear)
                                        
                                        Text(date.toString())
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .foregroundColor(isSelected ? .white : (day == 7 ? .red : .primary))
                                    }
                                })
                            } else {
                                Text(date.toString())
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func toggleButtonSelection(date: Date) {
        if let _ = selectedDate.firstIndex(of: date) {
            selectedDate.removeAll { $0 == date }
        } else if selectedDate.count < 7 {
            selectedDate.append(date)
        }
        
    }
    
    private func ButtonSelection(date: Date){
        selectedDate.removeAll()
        selectedDate.append(date)
        print(date)
    }
    
    private func dayText(week: Int, day: Int) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        dateComponents.day! += ((week * 7) + day - calendar.component(.weekday, from: firstDayOfMonth) + 1)
        return calendar.date(from: dateComponents)!
    }
}

struct CalendarTestView: View{
    @State var selectedDate = [Date()]
    var body: some View{
        CalendarView(selectedDate: $selectedDate)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTestView()
        CalendarTestView().preferredColorScheme(.dark)
    }
}
