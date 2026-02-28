//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 06/02/2026.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var arViewModel: ARViewModel
    @State private var isSplashActive = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if isSplashActive {
                SplashScreenView()
                    .transition(.opacity)
            } else if !hasSeenOnboarding {
                OnboardingView()
                    .transition(.opacity)
            } else {
                MainARView()
                    .environmentObject(arViewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isSplashActive = false
                }
            }
        }
    }
}

// main ar view
struct MainARView: View {
    @EnvironmentObject var arViewModel: ARViewModel
    @State private var showingHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background AR View
                ARViewContainer()
                    .environmentObject(arViewModel)
                    .ignoresSafeArea()
                
                // live bounds 
                if let currentDetection = arViewModel.currentDetection {
                    AROverlayView(detection: currentDetection)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: arViewModel.currentDetection?.id)
                }
                
                // scanning reticle 
                ScanningIndicatorView()
                    .environmentObject(arViewModel)
                
                // status ui
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 14) {
                            StatusPill(
                                text: arViewModel.isScanning ? "Detecting..." : "Paused",
                                color: arViewModel.isScanning ? .blue : .gray
                            )
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    arViewModel.toggleDetection()
                                }
                            }) {
                                Image(systemName: arViewModel.isScanning ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                        .padding()
                        .padding(.top, 4)
                    }
                    Spacer()
                }
                
                // sheet
                VStack {
                    Spacer()
                    if let currentDetection = arViewModel.currentDetection {
                        DangerCardView(detection: currentDetection) {
                            withAnimation(.spring()) {
                                arViewModel.dismissCurrentDetection()
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: arViewModel.currentDetection?.id)
            }
            .navigationTitle("SafeSpace")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                HistoryView()
                    .environmentObject(arViewModel)
            }
        }
        // debug logging
        .onChange(of: arViewModel.currentDetection?.id) { oldValue, newValue in
            if let result = arViewModel.currentDetection {
                print("⚠️ [DANGER DETECTED] \(result.formattedLabel) - \(Int(result.confidence * 100))%")
            }
        }
    }
}

struct StatusPill: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.85))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(ARViewModel())
}
