//
//  TimeTable.swift
//  calendarTest
//
//  Created by musung on 2023/07/14.
//

import Foundation

// calendar -> timeInterval로 slice해주기
// 09 ~ 24 까지 time

//1. timeTable에 Calendar 주입
//2. 9 - 24 ,interval 30인 table 만들기
//3. 이벤트를 알맞게 잘라 넣고, 일정 없는 곳에는 blankEvent 만들기
//4. 선택이 되면 잘라져있는 event들 다시 합쳐서 Calendar 형태로 return
struct TimeTableService{
    typealias MyCalendar = Dictionary<String,[Event]>
    var calendar: MyCalendar
    var interval: Int = 30
    var start : Int = 9
    var end : Int = 24
    
    public func getCalendarForTimeTable() -> MyCalendar{
        return matchCalendar()
    }
    
    private func makeBlankCalendar() -> MyCalendar{
        let slice = 60/interval
        let itemNum = (start - end) * slice
        var newCalendar = MyCalendar()
        self.calendar.keys.forEach { day in
            var events = [Event]()
            var tStart = DateUtil.formattedDateToDate(day + "09:00") // 이건 귀찮아서 그냥 했는데 수정해야함
            var tEnd = DateUtil.formattedDateToDate(day + "09:30")
            for _ in 0 ... itemNum{
                let event = Event(title: "blank", start: tStart, end: tEnd)
                tStart = tStart.advanced(by: 60*30)
                tEnd = tEnd.advanced(by: 60*30)
                events.append(event)
            }
            newCalendar.updateValue(events, forKey: day)
        }
        return newCalendar
    }
    private func matchCalendar() -> MyCalendar{
        var newCalendar = makeBlankCalendar()
        calendar.keys.forEach { day in
            calendar[day]!.forEach({ event in
                //이벤트의 startTime을 반내림
                var tStart = floorDateToNearest30Minutes(event.start)
                //이벤트의 endTime을 반올림
                let tEnd = roundDateToNearest30Minutes(event.end)
                while(tStart == tEnd){
                    let event = Event(title: event.title, start: tStart, end: tEnd)
                    for (index, value) in newCalendar[day]!.enumerated() {
                        if value.start ==  tStart{
                            newCalendar[day]![index] = event
                        }
                        tStart = tStart.advanced(by: 60*30)
                    }
                    tStart = tStart.advanced(by: 60*30)
                }

            })
        }
        return newCalendar
    }
    func roundDateToNearest30Minutes(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // 분을 30분 단위로 반올림
        let minuteRemainder = components.minute! % 30
        if minuteRemainder >= 15 {
            components.minute! += 30 - minuteRemainder
        } else {
            components.minute! -= minuteRemainder
        }
        
        // 초는 0으로 설정하여 반올림한 시간을 구함
        components.second = 0
        
        // 반올림된 Date를 가져옴
        let roundedDate = calendar.date(from: components)!
        return roundedDate
    }
    
    func floorDateToNearest30Minutes(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // 분을 30분 단위로 반내림
        let minuteRemainder = components.minute! % 30
        components.minute! -= minuteRemainder
        
        // 초는 0으로 설정하여 반내림한 시간을 구함
        components.second = 0
        
        // 반내림된 Date를 가져옴
        let floorDate = calendar.date(from: components)!
        return floorDate
    }
    
    
    
}

//1. 요일별 리스트 만들기
//2. local event -> startTime, endTime도 정해줘야하겠넹 ㅠ
//3.
