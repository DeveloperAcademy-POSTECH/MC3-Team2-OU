import Foundation
import SwiftUI

class CalcOksService: ObservableObject {
    @Published var result: [TimeOks]?
    @Published var isCalculating = false
    @Published var theTime = 1
    
    @MainActor
    func performCalculation(_ dateMembers : [DateMember]) async throws {
        isCalculating = true
        
        //try await
        //Task.sleep(nanoseconds: 1_000_000_000)  // Simulating an asynchronous operation
        let sum = try await getAvailableTime(dateMembers)
        result = sum
        isCalculating = false
    }
    
    private func getAvailableTime(_ members : [DateMember]) async throws -> [TimeOks] {
        // print(members[0].Activities[0].startDate)
        
        // [start, length] -> [start, start+1, start+2, .... start+length-1]
        func getStride(_ activity : DateEvent) -> [Int]{
            let startTime = Int(round(activity.startDate.timeIntervalSince1970/1800))
            let period = Int(round(activity.endDate.timeIntervalSince1970/1800)) - startTime
            return Array(stride(from:startTime, to: startTime + period, by : 1))}
        
        func getOktimes(_ member: DateMember) -> [Int]{
            let memberOkTimeMapped = member.dateEvents.map(getStride).flatMap{$0}
            return memberOkTimeMapped}
        
        //인원수 다음 가까운 시간으로 정렬
        func OksAndNearest(_ t1 : TimeOks, _ t2 : TimeOks) -> Bool {
            if t1.Oks == t2.Oks {
                return t1.timeInt < t2.timeInt
            } else {
                return t1.Oks > t2.Oks}}
        
        //가까운 시간으로 정렬
        func Nearest(_ t1 : TimeOks, _ t2 : TimeOks) -> Bool {
            return t1.timeInt < t2.timeInt}
        
        //주어진 minTime(30분 : 1, 1 시간 : 2, 1시간 30분 : 3 ....) 만큼 필터링
        func getMemberTimeOks(_ memberTimeOks : [TimeOks], _ minTime : Int) -> [TimeOks]{
            if memberTimeOks.count <= 1 {
                return memberTimeOks}
            let a1 = memberTimeOks.sorted(by: Nearest)
            var arr1 = [TimeOks]()
            for i in a1.indices {
                if i < a1.count - minTime + 1 && a1[i].timeInt + minTime - 1 == a1[i + minTime - 1].timeInt{
                    let aaron = a1[i..<(i+minTime)].map{$0.Oks}.min()!
                    arr1.append(TimeOks(timeInt: a1[i].timeInt, Oks: aaron))}}
            return arr1}
        
        //시간 길이만큼 filteringAndMapping
        let membersOkTimeMapped = members.map(getOktimes).flatMap{$0}

        // 원소 갯수 카운팅
        let countMembersOkTime = membersOkTimeMapped.reduce(into: [Int: Int]()) { counts, number in
            counts[number, default: 0] += 1}
        
        // startDate endDate 범위 정보 들어올 경우 해당 Date 범위만큼 [TimeOks] 배열 형성, 상단 countMembersOkTime 에서 해당 배열을 뺄셈하기
        
        //Dict [날짜절댓값/1800 : 가용인원] -> [구조체], 구조체(TimeOks){날짜 절댓값(timeInt) : Int , 가용인원(Oks) : Int}
        let memberTimeOks = countMembersOkTime.map{TimeOks(timeInt: $0.key, Oks: $0.value)}
        
        //주어진 시간만큼 필터링하기
        let memberMinTimeOks = getMemberTimeOks(memberTimeOks, self.theTime)
        
        //정렬하기
        let sortedMemberOks = memberMinTimeOks.sorted(by: OksAndNearest)
        
        //그냥 Print문 확인차 출력
        ///for TimeOks in sortedMemberOks{
        ///    let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval(TimeOks.timeInt*1800)))
        ///    print(time.year!, time.month!, time.day!, time.hour!, time.minute!, TimeOks.Oks)}
        return sortedMemberOks}
}
