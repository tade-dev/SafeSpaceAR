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
                    VStack(spacing: 32) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .foregroundColor(.red)
                        
                        Text("What We Detect")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            DangerRow(icon: "scissors", title: "Scissors & Knives", subtitle: "Sharp objects left in the open")
                            DangerRow(icon: "powerplug", title: "Electrical Outlets", subtitle: "Exposed sockets and loose cables")
                            DangerRow(icon: "bubbles.and.sparkles", title: "Cleaning Products", subtitle: "Harmful chemicals within reach")
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
                
                // Navigation/Action Button
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

// Subcomponent for simple icon/text pairing
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
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.red)
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
