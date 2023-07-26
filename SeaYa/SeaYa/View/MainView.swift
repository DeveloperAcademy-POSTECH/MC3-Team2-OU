//
//  MainView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var connectionManager = ConnectionService()
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        VStack {
              Text("안녕하세요, \(userData.nickname) 님")
                    .title(textColor: Color.primary)
                 
                  .padding()
                Text("hello")
                    .title(textColor: Color.primary)
            //MARK: Helia Test
            Button(action: {
                connectionManager.guest()
            }, label: {
                Circle()
                    .frame(width: 145, height: 145)
                    .foregroundColor(.blue)
            })
            
            Button(action: {
            }, label: {
                NavigationLink(
                    destination: MakingGroupView()
                        .navigationBarBackButtonHidden(),
                    label: {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                            
                            Text("방 만들기")
                                .foregroundColor(.white)
                        }
                    })
            })
            
            NavigationLink(
                isActive: .constant(connectionManager.reciveData != ""),
                destination: {
                    GuestCallingDone()
                }, label: {
                    EmptyView()
                }
            )
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData() // UserData 객체를 생성하여 nickname 설정
        
        return MainView().environmentObject(userData)
    }
}

