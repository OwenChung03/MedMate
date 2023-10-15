//
//  MedMateApp.swift
//  MedMate
//
//  Created by Owen Chung on 15/10/2023.
//
import SwiftUI
@main
struct YourAppNameApp: App {
    @State private var isDarkMode = true
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
