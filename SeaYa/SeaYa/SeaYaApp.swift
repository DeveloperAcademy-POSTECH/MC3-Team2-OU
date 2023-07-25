//
//  SeaYaApp.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/12.
//

import SwiftUI

@main
struct SeaYaApp: App {
    @StateObject private var userData = UserData()
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(userData)
//            TimeTable()
            MainView()
                .environmentObject(userData)
        }
    }
}
