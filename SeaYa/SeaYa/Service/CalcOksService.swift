import Foundation
import SwiftUI

//MARK: ListupData 넘겨주기
class CalcOksService: ObservableObject {
    @Published var result: [TimeOks]?
    @Published var isCalculating = false
    @Published var theTime : Int?
    @Published var dateMembers : [DateMember]?
    
    static let shared = CalcOksService()
    private init(){}
    
    @MainActor
    func performCalculation(_ dateMembers : [DateMember], by boundedDate : [BoundedDate]) async throws {
        isCalculating = true
        
        //try await
        //Task.sleep(nanoseconds: 1_000_000_000)  //Simulating an asynchronous operation
        let sum = try await getAvailableTime(dateMembers, by: boundedDate)
        result = sum
        isCalculating = false
    }
    
    private func getAvailableTime(_ members : [DateMember], by boundedDates : [BoundedDate]) async throws -> [TimeOks] {
        // print(members[0].Activities[0].startDate)
        
        // [start, length] -> [start, start+1, start+2, .... start+length-1]
        func getStride(_ activity : DateEvent) -> [Int]{
            let startTime = Int(round(activity.startDate.timeIntervalSince1970/1800))
            let period = Int(round(activity.endDate.timeIntervalSince1970/1800)) - startTime
            return Array(stride(from:startTime, to: startTime + period, by : 1))}
        
        func getStride(_ activity : BoundedDate) -> [Int]{
            let startTime = Int(round(activity.start.timeIntervalSince1970/1800))
            let period = Int(round(activity.end.timeIntervalSince1970/1800)) - startTime
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
        
        func getOKtimesBySubtract(_ timeInt : Int, using dictMemberTimeOKs : [Int : Int]) -> TimeOks {
            if let Oks =  dictMemberTimeOKs[timeInt] {
                return TimeOks(timeInt: timeInt, Oks: members.count - Oks)
            } else {
                return TimeOks(timeInt: timeInt, Oks: members.count)
            }
        }
        
        //시간 길이만큼 filteringAndMapping
        let membersOkTimeMapped = members.map(getOktimes).flatMap{$0}

        // 원소 갯수 카운팅
        let countMembersOkTime = membersOkTimeMapped.reduce(into: [Int: Int]()) { counts, number in
            counts[number, default: 0] += 1}
        
        // startDate endDate 범위 정보 들어올 경우 해당 Date 범위만큼 [TimeOks] 배열 형성, 상단 countMembersOkTime 에서 해당 배열을 뺄셈하기
        let boundedDatesMapped = boundedDates.map(getStride).flatMap{$0}
        let memberTimeOks = boundedDatesMapped.map{getOKtimesBySubtract($0, using: countMembersOkTime)}.filter{$0.Oks != 0}.sorted(by: Nearest)
        
        //주어진 시간만큼 필터링하기
//        let memberMinTimeOks = getMemberTimeOks(memberTimeOks, self.theTime)
        guard let theTime = self.theTime else {
            print("기간 설정을 입력받지 않아 30분단위로 순위 정렬")
            return getMemberTimeOks(memberTimeOks, 1).sorted(by: OksAndNearest)
        }
        let memberMinTimeOks = getMemberTimeOks(memberTimeOks, theTime)
        
        //정렬하기
        let sortedMemberOks = memberMinTimeOks.sorted(by: OksAndNearest)
        
        /// You can check values by using below commands
        ///
        ///for TimeOks in sortedMemberOks{
        ///    let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeIntervalSince1970: TimeInterval(TimeOks.timeInt*1800)))
        ///    print(time.year!, time.month!, time.day!, time.hour!, time.minute!, TimeOks.Oks)}
        ///print(sortedMemberOks.last?.timeInt)
        
        return sortedMemberOks}
    
    func groupByConsecutiveTime(_ sortedMemberTimeOks : [TimeOks]) -> [[TimeOks]]{
        let groupedNumbers = sortedMemberTimeOks.reduce(into: [[TimeOks]]()) { result, number in
            if let lastGroup = result.last, let lastNumber = lastGroup.last, lastNumber.timeInt == number.timeInt - 1 {
                result[result.count - 1].append(number)
            } else {
                result.append([number])
            }
        }
        return groupedNumbers
    }
}
