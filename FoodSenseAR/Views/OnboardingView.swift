//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 25/02/2026.
//


import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    // Page 1
                    OnboardingPage(
                        iconName: "shield.fill",
                        title: "Welcome to SafeSpace",
                        subtitle: "Protecting your little ones\none scan at a time."
                    )
                    .tag(0)
                    
                    // Page 2
                    OnboardingPage(
                        iconName: "camera.viewfinder",
                        title: "How It Works",
                        subtitle: "Point your camera around the house.\nOur AI detects household dangers instantly\nand overlays AR warnings in real time."
                    )
                    .tag(1)
                    
                    // Page 3
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                            .foregroundColor(.red)
                        
                        Text("What We Detect")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16) {
                                DangerRow(emoji: "✂️", title: "Scissors", subtitle: "Sharp objects left in the open")
                                DangerRow(emoji: "🔪", title: "Knives", subtitle: "Unsecured knives in child spaces")
                                DangerRow(emoji: "🔥", title: "Matches & Lighters", subtitle: "Fire hazards left unattended")
                                DangerRow(emoji: "🍶", title: "Glass Bottles", subtitle: "Breakable glass in low areas")
                                DangerRow(emoji: "🌡️", title: "Hot Appliances", subtitle: "Plugged in or cooling appliances")
                                DangerRow(emoji: "🛍️", title: "Plastic Bags", subtitle: "Suffocation hazards in reach")
                                DangerRow(emoji: "⚡", title: "Electrical Hazards", subtitle: "Exposed sockets and loose cables")
                                DangerRow(emoji: "🧴", title: "Liquid & Chemical", subtitle: "Harmful chemicals within reach")
                            }
                            .padding(.horizontal, 32)
                            .padding(.bottom, 20)
                        }
                    }
                    .padding(.top, 50)
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                Spacer(minLength: 0)
                
                if currentPage == 2 {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            hasSeenOnboarding = true
                        }
                    }) {
                        Text("Get Started")
                    }
                    .buttonStyle(SafeSpaceButtonStyle())
                    .padding()
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                    }
                    .buttonStyle(SafeSpaceButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let iconName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 140, height: 140)
                .foregroundColor(.red)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
        }
        .padding()
    }
}

struct DangerRow: View {
    let emoji: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.title2)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
