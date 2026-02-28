//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 06/02/2026.
//


import Foundation

struct DetectionHistoryItem: Identifiable {
    let id = UUID()
    let label: String
    let formattedLabel: String
    let confidence: Float
    let safetyTip: String
    let dangerLevel: DangerLevel
    let timestamp: Date
    
    init(from result: DetectionResult) {
        self.label = result.label
        self.formattedLabel = result.formattedLabel
        self.confidence = result.confidence
        self.safetyTip = result.safetyTip
        self.dangerLevel = result.dangerLevel
        self.timestamp = Date()
    }
}
