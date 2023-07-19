//
//  ekTest.swift
//  calendarTest
//
//  Created by musung on 2023/07/09.
//

import Foundation
import EventKit

class RemoteCalendarRepository{
    static let shared = RemoteCalendarRepository()
    // store 생성
    private let store : EKEventStore
    
    private init() {
        self.store = EKEventStore()
    }

    
    //일정 생성
    public func createEvent(event : Event)async throws -> Bool{
        
        let isAccess = try await isAccessPermission()
        // 접근 허가
        if isAccess{
            let ekEvent = getEkEvent(event: event)
            do{
                try store.save(ekEvent, span: .thisEvent, commit: true)
            }
            catch{
                print("createEventError")
            }
            return true
        }
        // 접근 실패
        else{
            return false
        }
    }
    //일정 받아오기
    public func fetchEvent(start:Date,end:Date)async throws -> [Event]{
        let isAccess = try await isAccessPermission()
        let predictate = getPredictate(start: start, end: end)
        // 접근 허가
        if isAccess{
            let events = store.events(matching: predictate)
            return events.map { ekEvent in
                EKEventToEvent(event: ekEvent)
            }
        }
        // 접근 실패
        else{
            return []
        }
    }
    public func removeEvent(event:EKEvent) throws ->(){
        try store.remove(event, span: .thisEvent)
    }
    //일정 삭제
    
    private func EKEventToEvent(event: EKEvent) -> Event{
        return Event(title: event.title, start: event.startDate, end: event.endDate)
    }
    //calendar 가져오기
    private func getCalendar() -> EKCalendar{
        let calendars = store.calendars(for: .event)
        let calendar = calendars.filter { calendar in
            calendar.title == "캘린더" || calendar.title == "Calendar"
        }.first
        return calendar!
    }
    //이벤트 생성하기
    private func getEkEvent(event : Event) -> EKEvent{
        let ekEvent = EKEvent(eventStore: store)
        ekEvent.calendar = getCalendar()
        ekEvent.title = event.title
        ekEvent.startDate = event.start
        ekEvent.endDate = event.end
        return ekEvent
    }
    //predictate 생성 -> 시작날짜, 끝 날짜, 캘린더 종류 생성해서 fetch할 때 사용
    private func getPredictate(start:Date,end:Date) -> NSPredicate{
        return store.predicateForEvents(withStart: start, end: end, calendars: [getCalendar()])
    }
    // 캘린더 권한 요청
    private func isAccessPermission() async throws -> Bool {
        var isRequestAccessed = false
        switch EKEventStore.authorizationStatus(for: .event) {
        // 권한 설정 안했으면 권한 설정 팝업 알림
        case .notDetermined:
            isRequestAccessed = try await store.requestAccess(to: .event)
        case .restricted:
            print("EventManager: restricted")
        //사용자 요청 거절 -> 직접 권한 설정으로 -> 이건 알려주는 페이지 필요할 듯
        case .denied:
            print("EventManager: denied")
        //이미 권한 있음
        case .authorized:
            print("EventManager: autorized")
            isRequestAccessed = true
        default:
            print(#fileID, #function, #line, "unknown")
        }
        return isRequestAccessed
    }
    
}
