//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 15/02/2026.
//


import SwiftUI

struct AROverlayView: View {
    let detection: DetectionResult
    @State private var isPulsing = false
    
    // haptics!
    private let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [.clear, .clear, detection.dangerLevel.color.opacity(0.1), detection.dangerLevel.color.opacity(0.35)]),
                center: .center,
                startRadius: 100,
                endRadius: UIScreen.main.bounds.width
            )
            .ignoresSafeArea()
            .opacity(isPulsing ? 1.0 : 0.4)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isPulsing)
            
            // target box
            RoundedRectangle(cornerRadius: 16)
                .stroke(detection.dangerLevel.color, lineWidth: 4)
                .frame(width: 250, height: 250)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(detection.dangerLevel.color.opacity(isPulsing ? 0.2 : 0.05))
                )
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                    value: isPulsing
                )
                .onAppear {
                    isPulsing = true
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred()
                }
            
            // overlays
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: detection.dangerLevel.icon)
                            .font(.headline)
                        
                        Text(detection.formattedLabel)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(detection.dangerLevel.color)
                    .clipShape(Capsule())
                    .shadow(radius: 4)
                    
                    Text(detection.safetyTip)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(maxWidth: 300)
                        .background(Color.black.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                }
                .offset(y: -140) 
            }
        }
    }
}

#Preview {
    AROverlayView(
        detection: DetectionResult(
            label: "scissors",
            confidence: 0.95
        )
    )
    .background(Color.gray)
}
