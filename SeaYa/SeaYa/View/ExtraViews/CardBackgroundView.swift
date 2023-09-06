//
//  SwiftUIView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//
import SwiftUI

struct CardBackgroundView: View {
    @State private var isCardVisible = false

    var body: some View {
        ZStack {
            VStack {
                // Main UI
                Text("Main Content")
                    .font(.largeTitle)

                Button(action: {
                    isCardVisible.toggle()
                }) {
                    Text("Show Card")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .blur(radius: isCardVisible ? 50 : 0)

            if isCardVisible {
                Rectangle()
                    .fill(Color(red: 0.45, green: 0.45, blue: 0.45).opacity(0.5))
                    .ignoresSafeArea()
            }
        }
    }
}

struct CardBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackgroundView()
        CardBackgroundView().preferredColorScheme(.dark)
    }
}
