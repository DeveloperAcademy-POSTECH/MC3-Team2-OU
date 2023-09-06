//
//  SeaYaApp.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/12.
//

import SwiftUI

@main
struct SeaYaApp: App {
    @StateObject var connectionManger = ConnectionService()
    @StateObject var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectionManger)
                .environmentObject(userData)
        }
    }
}
