//
//  CheckTimeDoneView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct CheckTimeDoneView: View {
    @ObservedObject var connectionManager: ConnectionService
    
    var body: some View {
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
    }
}

struct CheckTimeDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CheckTimeDoneView(connectionManager: ConnectionService())
    }
}
