//
//  LaunchScreenView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        // 런치 스크린 이미지 표시
        Image("launch")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 90, maxHeight: .infinity)
    }
}

