//
//  CalendarView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedButtons: [Date] = []
    @Binding var selectedDate: [Date]
    
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
                            let isSelected = selectedButtons.contains(date)
                            
                            if date >= currentDate && date < nextDate {
                                Button(action: {
                                    toggleButtonSelection(date: date)
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(isSelected ? Color.blue : Color.clear)
                                        
                                        Text(date.toString())
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .foregroundColor(isSelected ? .white : (day == 7 ? .red : .black))
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
    
    func toggleButtonSelection(date: Date) {
        if let index = selectedButtons.firstIndex(of: date) {
            selectedButtons.remove(at: index)
            selectedDate.removeAll { $0 == date }
        } else if selectedButtons.count < 7 {
            selectedButtons.append(date)
            selectedDate.append(date)
        }
    }
    
    func dayText(week: Int, day: Int) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        dateComponents.day! += ((week * 7) + day - calendar.component(.weekday, from: firstDayOfMonth) + 1)
        return calendar.date(from: dateComponents)!
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: .constant([Date]()))
    }
}
