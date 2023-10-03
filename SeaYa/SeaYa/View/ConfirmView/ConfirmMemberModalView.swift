//
//  ConfirmStartView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/21.
//

import SwiftUI

struct ConfirmMemberModalView: View {
    @Binding var selectedMembers: [DateMember]
    let columns: [GridItem] = Array(repeating: .init(), count: 3) // 그리드 여백
    var members: [DateMember]
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(hex: "#D3D3D3"))
                .frame(width: 34, height: 5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            Text("참여인원").headline(textColor: .primaryColor).padding(.bottom, 30)
            LazyVGrid(columns: columns) {
                ForEach(Array(zip(members.indices, members)), id: \.0) { _, member in
                    Button(
                        action: {
                            if selectedMembers.contains(member) == false {
                                selectedMembers.append(member)
                            } else {
                                selectedMembers = selectedMembers.filter { $0 != member }
                            }
                        },
                        label: {
                            ZStack {
                                VStack {
                                    Image(member.profileImage)
                                        .resizable()
                                        .frame(width: 54, height: 54)
                                    Text(member.name)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.primary)
                                }
                                VStack {
                                    HStack {
                                        Spacer()
                                        ZStack {
                                            Circle().fill(Color.white)
                                            if selectedMembers.contains(member) == false {
                                                Image(systemName: "plus.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(Color.blue)
                                            } else {
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(Color.red)
                                            }
                                        }.frame(width: 20, height: 20)
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 54, height: 87)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 2, trailing: 16))
                        }
                    )
                }
            }.frame(minHeight: 200)
        }.padding(EdgeInsets(top: 0, leading: 82, bottom: 40, trailing: 82))
    }
}

struct ConfirmMemberModalTestView: View {
    @State private var isModalPresented = true
    var members = [
        DateMember(id: UUID(), name: "가온"),
        DateMember(id: UUID(), name: "기현"),
        DateMember(id: UUID(), name: "새뮤엘"),
        DateMember(id: UUID(), name: "신디"),
        DateMember(id: UUID(), name: "하니"),
        DateMember(id: UUID(), name: "헬리아"),
    ]
    @State private var selectedMembers: [DateMember] = []
    var body: some View {
        VStack {
            Button("Show Modal") {
                isModalPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isModalPresented, content: {
            ConfirmMemberModalView(selectedMembers: $selectedMembers, members: members)
                .presentationDetents([.height(354)])
                .presentationCornerRadius(32)
        })
    }
}

#Preview{
    ConfirmMemberModalTestView().environment(\.locale, .init(identifier: "ko"))
}
#Preview{
    ConfirmMemberModalTestView().environment(\.locale, .init(identifier: "ko"))
        .preferredColorScheme(.dark)
}


