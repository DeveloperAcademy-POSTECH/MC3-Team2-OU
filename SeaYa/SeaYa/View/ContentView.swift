//
//  ContentView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @AppStorage("isNicknameSettingCompleted") private var isNicknameSettingCompleted = false
    @AppStorage("isFixedTimeSettingCompleted") private var isFixedTimeSettingCompleted = false
    @State private var isLaunchScreenVisible = true
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
            } else if isOnboardingCompleted {
                if isNicknameSettingCompleted {
                    if isFixedTimeSettingCompleted {
                        MainView() .environmentObject(userData)
                    } else {
                        FixedTimeView(isFixedTimeSettingCompleted: $isFixedTimeSettingCompleted)
                    }
                } else {
                    NicknameView(isNicknameSettingCompleted: $isNicknameSettingCompleted) .environmentObject(userData)
                }
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

