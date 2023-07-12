//
//  NickNameView.swift
//  HaniSeaya
//
//  Created by 김하은 on 2023/07/11.
//
import SwiftUI

struct NicknameView: View {
    @Binding var isNicknameSettingCompleted : Bool
    @State private var nickname = ""
    @EnvironmentObject private var userData: UserData

    var body: some View {
        VStack {
            TextField("닉네임을 입력하세요", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // 닉네임 확인 로직 추가

                if !nickname.isEmpty {
                  isNicknameSettingCompleted = true
                  userData.nickname = nickname
              }
            }) {
                Text("확인")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}
