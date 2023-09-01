//
//  ContentView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isNicknameSettingCompleted") private var isNicknameSettingCompleted = false
    @AppStorage("isFixedTimeSettingCompleted") private var isFixedTimeSettingCompleted = false
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @State private var isLaunchScreenVisible = true
    @EnvironmentObject private var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData

    var body: some View {
        Group {
            if isLaunchScreenVisible {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLaunchScreenVisible = false
                            }
                        }
                    }
            } else if !isNicknameSettingCompleted {
                NicknameView(isNicknameSettingCompleted: $isNicknameSettingCompleted)
            } else if !isFixedTimeSettingCompleted {
                FixedTimeView(isFixedTimeSettingCompleted: $isFixedTimeSettingCompleted)
            } else if !isOnboardingCompleted {
                OnboardingDoneView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
        ContentView()
            .environmentObject(UserData())
            .preferredColorScheme(.dark)
    }
}
