//
//  FixedTimeView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct FixedTimeView: View {
    @Binding var isFixedTimeSettingCompleted: Bool
    @State private var fixedTime = ""

    var body: some View {
        VStack {
            TextField("고정 시간을 입력하세요", text: $fixedTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // 고정 시간 확인 로직 추가

                if !fixedTime.isEmpty {
                    isFixedTimeSettingCompleted = true
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
