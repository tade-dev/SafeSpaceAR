//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 15/02/2026.
//


import SwiftUI

struct DangerCardView: View {
    let detection: DetectionResult
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            Image(systemName: detection.dangerLevel.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .foregroundColor(detection.dangerLevel.color)
            
            Text(detection.formattedLabel)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(detection.dangerLevel.label.uppercased())
                .font(.caption)
                .fontWeight(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(detection.dangerLevel.color.opacity(0.2))
                .foregroundColor(detection.dangerLevel.color)
                .clipShape(Capsule())
            
            Text(detection.safetyTip)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Text("Detected with \(Int(detection.confidence * 100))% confidence")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Button(action: onDismiss) {
                Text("Dismiss Safety Warning")
            }
            .buttonStyle(SafeSpaceButtonStyle(backgroundColor: detection.dangerLevel.color))
            .padding(.top, 8)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: -5)
        .padding(.horizontal)
    }
}
