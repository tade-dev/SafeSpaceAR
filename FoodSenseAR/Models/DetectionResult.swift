//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 06/02/2026.
//


import Foundation
import SwiftUI

enum DangerLevel {
    case high
    case medium
    case low
    
    var color: Color {
        switch self {
        case .high: return Color(red: 255/255, green: 59/255, blue: 48/255)
        case .medium: return Color(red: 255/255, green: 149/255, blue: 0/255)
        case .low: return Color(red: 0/255, green: 122/255, blue: 255/255)
        }
    }
    
    var label: String {
        switch self {
        case .high: return "High Danger"
        case .medium: return "Medium Danger"
        case .low: return "Low Danger"
        }
    }
    
    var icon: String {
        switch self {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
}

struct DetectionResult: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    
    var dangerLevel: DangerLevel {
        switch label {
        case "knives", "matches_lighters", "liquid_chemical_hazards":
            return .high
        case "scissors", "hot_appliances", "electrical_outlets_cables", "glass_bottles":
            return .medium
        case "plastic_bags":
            return .low
        default:
            return .medium
        }
    }
    
    var formattedLabel: String {
        switch label {
        case "scissors":
            return "Scissors"
        case "knives":
            return "Knives"
        case "matches_lighters":
            return "Matches & Lighters"
        case "glass_bottles":
            return "Glass Bottles"
        case "hot_appliances":
            return "Hot Appliances"
        case "plastic_bags":
            return "Plastic Bags"
        case "electrical_outlets_cables":
            return "Electrical Hazards"
        case "liquid_chemical_hazards":
            return "Liquid & Chemical Hazards"
        default:
            return label.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
    
    var safetyTip: String {
        switch label {
        case "scissors":
            return "Store scissors in a drawer with a child lock"
        case "knives":
            return "Keep all knives in a locked knife block or high drawer"
        case "matches_lighters":
            return "Store in a high locked cupboard, never leave unattended"
        case "glass_bottles":
            return "Replace with plastic alternatives in child accessible areas"
        case "hot_appliances":
            return "Unplug when not in use and store out of reach"
        case "plastic_bags":
            return "Store bags in a high cupboard, never leave within child's reach"
        case "electrical_outlets_cables":
            return "Use outlet covers and keep cables tucked away"
        case "liquid_chemical_hazards":
            return "Store chemicals in high locked cupboards out of reach"
        default:
            return ""
        }
    }
}
