//
//  calendar.swift
//  calendarTest
//
//  Created by musung on 2023/07/13.
//

import Foundation

class CalendarService {
    typealias Calendar = Dictionary<String,[Event]>
    static let shared = CalendarService()
    private init(){}
    //local event -> calendar
    public func makeCalendar(_ selectedDays: [String],_ localEvents:[LocalEvent])->Calendar{
        let events = localEventsToEvent(localEvents, selectedDays)

        return eventsToCalendar(events)
    }
    //remote event -> calendar
    public func makeCalendar(_ selectedDays: [String],_ remoteEvents:[Event])->Calendar{
        // 하루 넘어가는 이벤트가 있으면 다음날로 넘기는 로직 추가
        var calendar = Calendar()
        remoteEvents.forEach { event in
            let date = DateUtil.getFormattedDate(event.start)
            var pre = calendar[date] ?? []
            pre.append(event)
            calendar.updateValue(pre, forKey: date)
        }
        return calendar
    }
    
    public func mergeCalendar(_ calendar1: Calendar, _ calendar2: Calendar) -> Calendar{
        return calendar1.merging(calendar2) { events1,events2 in
            events1 + events2
        }
    }
    
    
    private func localEventToEvent(_ localEvent:LocalEvent, _ day: String) -> Event{
        return Event(title: localEvent.title, start: localEvent.start, end: localEvent.end)
    }
    
    private func findDateWithWeekDay(_ selectedDays:[String],_ weekDay: WeekDay)->[String]{
        return selectedDays.filter { day in
            DateUtil.dateToWeekDay(day) == weekDay
        }
    }
    private func localEventsToEvent(_ localEvents: [LocalEvent],_ selectedDays: [String]) -> [Event]{
        var events = [Event]()
        localEvents.forEach { localEvent in
            let weekDays = localEvent.days
            weekDays.forEach { day in
                let Dates = findDateWithWeekDay(selectedDays, day)
                Dates.forEach { date in
                    let start = DateUtil.dayPlusTime(date, localEvent.start)
                    let end = DateUtil.dayPlusTime(date, localEvent.end)
                    let event = Event(title: localEvent.title, start: start, end: end)
                    events.append(event)
                }
            }
        }
        return events
    }
    
    private func eventsToCalendar(_ events: [Event]) -> Calendar{
        var calendar = Calendar()
        events.forEach { event in
            let date = DateUtil.getFormattedDate(event.start)
            var pre = calendar[date] ?? []
            pre.append(event)
            calendar.updateValue(pre, forKey: date)
        }
        return calendar
    }
    }
    

    //1. 요일 List 받기
    // <요일 ,일정>
    //일주일 이상의 일정이 필요할 수도 있음.  -> 요청 요일 리스트를 받으면 리스트에 해당하는 모든 일정
    //30분 기준이지만 5분 기준이 될 수도 있음 -> interval을 변수로 만들어서 나눠주기
    
    //기능
    // 1. local, remote 합쳐진 캘린더 return
    
    // 변경가능 사항 -> 일주일 or 2주일이 될 수도 있음
    // 선택 요일 받았을 때 내 캘린더 줘야해~!
    // 선택 요일도 일주일 -> 2주 가 될 수도 있음
    
    //1. calendar 정보 fetch()
    //2. 받은 정보를 calendar 형태로 제공
    
    //todo
    //1. mergedCalendar -> customList
    //2. interval로 30분 지정
    //3. mergedCalendar에 있는 일정 timeTable로 만들기
        // 1. 09시 ~ 24시 까지 30분 간격의 리스트
        // 2.
    //2. custom

