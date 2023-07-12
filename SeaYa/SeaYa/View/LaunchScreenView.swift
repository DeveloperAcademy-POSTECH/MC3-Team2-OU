//
//  LaunchScreenView.swift
//  HaniSeaya
//
//  Created by 김하은 on 2023/07/11.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        // 런치 스크린 이미지 표시
        Image("launch")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 200, maxHeight: .infinity)
    }
}
