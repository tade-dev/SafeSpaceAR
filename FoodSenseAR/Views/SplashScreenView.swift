//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 25/02/2026.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "shield.checkerboard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
                    .scaleEffect(isPulsing ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                
                Text("SafeSpace")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    SplashScreenView()
}
