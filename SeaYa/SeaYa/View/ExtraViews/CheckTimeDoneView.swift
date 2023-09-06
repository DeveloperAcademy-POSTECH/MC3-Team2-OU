//
//  CheckTimeDoneView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct CheckTimeDoneView: View {
    @EnvironmentObject var connectionManager: ConnectionService
    @ObservedObject var calcOksManager = CalcOksService.shared
    @State var period = 1
    @State var listUpViewResult = ListUpViewResult()

    var body: some View {
        VStack {
            // Host
            if !connectionManager.isHosting {
                if connectionManager.listUP.count == connectionManager.peers.count + 1 {
                    // MARK: ListUpView Data 수정

                    ListUpView(forGuest: false, timeOkGroup: listUpViewResult.result, period: connectionManager.groupInfo?.estimatedTime ?? 1)
                } else {
                    WaitingForConfirmView()
                }
            }
            // Guest
            else {
                if connectionManager.listUpViewResult != nil && connectionManager.scheduleDone == nil {
                    ListUpView(
                        forGuest: true,
                        timeOkGroup: connectionManager.listUpViewResult?.result ?? listUpViewResult.result,
                        period: connectionManager.groupInfo?.estimatedTime ?? 1
                    )
                } else if connectionManager.scheduleDone != nil {
                    ResultView()
                } else {
                    WaitingForConfirmView()
                }
            }
        }
        .onReceive(connectionManager.$listUP) { _ in
            // 중복원소 제거
            if connectionManager.listUP.count == connectionManager.peers.count + 1 && !connectionManager.isHosting {
                Task {
                    calcOksManager.theTime = connectionManager.groupInfo?.estimatedTime ?? 1
                    calcOksManager.dateMembers = connectionManager.listUP
                    try await calcOksManager.performCalculation(connectionManager.listUP, by: [])
                    let m = ListUpViewResult(result: calcOksManager.groupByConsecutiveTime(calcOksManager.result!))
                    listUpViewResult = m
                    connectionManager.setListUpViewResult(m)
                    connectionManager.sendListUPInfoToGuest(m)
                }
            }
        }
    }
}

struct CheckTimeDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CheckTimeDoneView()
            .environmentObject(ConnectionService())
        CheckTimeDoneView()
            .environmentObject(ConnectionService())
            .preferredColorScheme(.dark)
    }
}
