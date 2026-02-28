//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 06/02/2026.
//


import Foundation
import CoreGraphics

enum DangerCategory: String, CaseIterable {
    case scissorsKnives = "scissors_knives"
    case electricalOutletsCables = "electrical_outlets_cables"
    case cleaningProducts = "cleaning_products"
    case safe = "safe"
    
    var isDangerous: Bool {
        return self != .safe
    }
}

struct DetectedDanger: Identifiable {
    let id = UUID()
    let category: DangerCategory
    let confidence: Float
    let boundingBox: CGRect
}
