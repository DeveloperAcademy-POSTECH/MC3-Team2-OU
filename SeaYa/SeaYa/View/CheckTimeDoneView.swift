//
//  CheckTimeDoneView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct CheckTimeDoneView: View {
    @ObservedObject var connectionManager: ConnectionService
    @ObservedObject var calcOksManager = CalcOksService.shared
    @State var period = 1
    @State var ListUpViewResult : [[TimeOks]] = []
    
    var body: some View {
        VStack{
            //Host
            if !connectionManager.isHosting {
                if connectionManager.listUP.count == connectionManager.peers.count{
                    //MARK: ListUpView Data 수정
                    ListUpView(timeOkGroup : [[TimeOks(timeInt: 940614, Oks: 2)],
                                              [TimeOks(timeInt: 940620, Oks: 2),
                                               TimeOks(timeInt: 940621, Oks: 2)],
                                              [TimeOks(timeInt: 940615, Oks: 1),
                                               TimeOks(timeInt: 940616, Oks: 1)],
                                              [TimeOks(timeInt: 940622, Oks: 1),
                                               TimeOks(timeInt: 940623, Oks: 1)],
                                              [TimeOks(timeInt: 940625, Oks: 1),
                                               TimeOks(timeInt: 940626, Oks: 1)]],
                               period: 1)
                    //ListUpView(timeOkGroup: ListUpViewResult, period: period)
                    .onAppear() {
                        connectionManager.send(true, messageType: .CheckTimeDone)
                    }
                }else {
                    WaitingForConfirmView()
                }
            }
            //Guest
            else {
                if connectionManager.isCheckTimeDone && connectionManager.scheduleDone == nil{
                    GuestWaitingForConfirmView()
                }else if connectionManager.scheduleDone != nil {
                    ResultView(connectionManager: connectionManager)
                }else {
                    WaitingForConfirmView()
                }
            }
        }.onReceive(connectionManager.$listUP){ _ in
            // 중복원소 제거
            var idArrayWithDuplicates = connectionManager.listUP.map{$0.id}
            
            var seenElement = Set<UUID>()
            var uniqueArray = [DateMember]()
            
            for (element, listElement) in zip(idArrayWithDuplicates, connectionManager.listUP) {
                if !seenElement.contains(element) {
                    seenElement.insert(element)
                    uniqueArray.append(listElement)
                }
            }
            
            connectionManager.listUP = uniqueArray
            if connectionManager.listUP.count == connectionManager.peers.count && !connectionManager.isHosting {
                Task{
                    calcOksManager.theTime = period
                    calcOksManager.dateMembers = connectionManager.listUP
                    try await calcOksManager.performCalculation(connectionManager.listUP, by: [])
                    ListUpViewResult = calcOksManager.groupByConsecutiveTime(calcOksManager.result!)
                }
            }
        }
    }
}

struct CheckTimeDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CheckTimeDoneView(connectionManager: ConnectionService())
    }
}
