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
                    if connectionManager.listUP.count == connectionManager.peers.count+1{
                        //MARK: ListUpView Data 수정
                        ListUpView(connectionManager: connectionManager, forGuest: false, timeOkGroup: ListUpViewResult, period: connectionManager.groupInfo?.estimatedTime ?? 1)
                            .onAppear() {
                                connectionManager.send(true, messageType: .CheckTimeDone)
                            }
                    }else {
                        WaitingForConfirmView()
                    }
                }
                //Guest
                else {
                    if connectionManager.isCheckTimeDone.isCheckTimeDone && connectionManager.scheduleDone == nil{
                        GuestWaitingForConfirmView()
                    }else if connectionManager.scheduleDone != nil {
                        ResultView(connectionManager: connectionManager)
                    }else {
                        WaitingForConfirmView()
                    }
                }
            }
            .onReceive(connectionManager.$listUP){ _ in
                // 중복원소 제거
                if connectionManager.listUP.count == connectionManager.peers.count+1 && !connectionManager.isHosting {
                    Task{
                        connectionManager.send(true, messageType: .CheckTimeDone)
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
