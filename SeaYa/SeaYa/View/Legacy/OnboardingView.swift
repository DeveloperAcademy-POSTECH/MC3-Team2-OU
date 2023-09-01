//
//  OnboardingView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPageIndex = 0
    private let onboardingPages = [
        OnboardingPage(imageName: "onboarding1", title: "Onboarding 1", description: "Description 1"),
        OnboardingPage(imageName: "onboarding2", title: "Onboarding 2", description: "Description 2"),
        OnboardingPage(imageName: "onboarding3", title: "Onboarding 3", description: "Description 3"),
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPageIndex) {
                ForEach(0 ..< onboardingPages.count) { index in
                    OnboardingPageView(onboardingPage: onboardingPages[index])
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .padding(.vertical, 20)

            Button(action: {
                withAnimation {
                    if currentPageIndex < onboardingPages.count - 1 {
                        currentPageIndex += 1
                    } else {
                        isOnboardingCompleted = true
                    }
                }
            }) {
                Text(currentPageIndex < onboardingPages.count - 1 ? "다음" : "시작하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let onboardingPage: OnboardingPage

    var body: some View {
        VStack(spacing: 20) {
            Image(onboardingPage.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)

            Text(onboardingPage.title)
                .font(.title)
                .fontWeight(.bold)

            Text(onboardingPage.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
