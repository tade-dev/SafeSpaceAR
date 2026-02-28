//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 06/02/2026.
//


import SwiftUI

@main
struct SafeSpaceApp: App {
    @StateObject private var arViewModel = ARViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(arViewModel)
        }
    }
}
