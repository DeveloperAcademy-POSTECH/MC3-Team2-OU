//
//  HostCallingView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/24.
//

import SwiftUI

struct HostCallingView: View {
    @ObservedObject private var connectionManager = ConnectionService()
    @State private var moveToDoneView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(connectionManager.foundPeers, id: \.self) { peer in
                    Button(action: {
                        guard let session = connectionManager.session else {return}
                        connectionManager.browser?.invitePeer(
                            peer,
                            to: session,
                            withContext: nil,
                            timeout: 10
                        )
                    }, label: {
                        VStack {
                            Circle()
                                .fill()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                            Text(peer.displayName)
                                .foregroundColor(.black)
                        }
                    })
                }
                .padding(.top, 100)
                .frame(height: 100)
                
                Spacer(minLength: 0)
                
                ZStack {
                    Circle()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .opacity(0.2)
                    Circle()
                        .frame(width: 282, height: 282)
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .opacity(0.4)
                    Circle()
                        .frame(width: 220, height: 220)
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .opacity(0.6)
                    Button (action: {
                        moveToDoneView = true
                    }, label: {
                        NavigationLink(
                            destination: HostCallingDone()
                                .onAppear{
                                    connectionManager.sendAllGuest()
                                },
                            isActive: $moveToDoneView,
                            label: {
                                Circle()
                                    .frame(width: 145, height: 145)
                                    .foregroundColor(.white)
                            }
                        )
                        
                    })
                    VStack {
                        Text("그룹 확정")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.leading, 8)
                            
                            Text("\(connectionManager.peers.count)명")
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.trailing, 8)
                        }
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, 21)
                
                VStack {
                    Text("그룹원을 찾고 있어요")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text("추가할 그룹원을 선택하고 그룹을 확정하세요")
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 35, leading: 20, bottom: 140, trailing: 20))
            }
            .onAppear() {
                connectionManager.host()
            }
            .ignoresSafeArea()
            .background(Color.blue)
            
            .toolbar {
                Button(action: {
                }, label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.white)
                        .opacity(0.5)
                })
            }
        }
    }
}

struct HostCallingView_Previews: PreviewProvider {
    static var previews: some View {
        HostCallingView()
    }
}
