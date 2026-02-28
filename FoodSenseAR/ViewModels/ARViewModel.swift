//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 14/02/2026.
//


import Foundation
import Combine
import SwiftUI

class ARViewModel: ObservableObject {
    @Published var isScanning: Bool = true
    @Published var currentDetection: DetectionResult?
    @Published var detectionHistory: [DetectionHistoryItem] = []
    
    // Scanning state
    @Published var scanningTarget: DetectionResult?
    @Published var scanningProgress: CGFloat = 0.0
    
    private var scanTimer: Timer?
    private var currentTargetLabel: String?
    
    // MARK: - Update Methods
    func updateDetection(_ result: DetectionResult?) {
        DispatchQueue.main.async {
            guard self.isScanning, self.currentDetection == nil else { return }
            
            if let result = result {
                guard self.currentTargetLabel != result.label else { return }
                self.startScanning(for: result)
            } else {
                self.resetScanning()
            }
        }
    }
    
    private func startScanning(for result: DetectionResult) {
        resetScanning()
        self.currentTargetLabel = result.label
        self.scanningTarget = result
        self.scanningProgress = 0.0
        
        let startTime = Date()
        self.scanTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / 1.2, 1.0)
            
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.016)) {
                    self.scanningProgress = CGFloat(progress)
                }
                
                if progress >= 1.0 {
                    self.completeScanning(with: result)
                }
            }
        }
    }
    
    private func completeScanning(with result: DetectionResult) {
        resetScanning()
        self.currentDetection = result
        self.addToHistory(result)
    }
    
    private func resetScanning() {
        self.scanTimer?.invalidate()
        self.scanTimer = nil
        self.currentTargetLabel = nil
        
        withAnimation(.easeOut) {
            self.scanningTarget = nil
            self.scanningProgress = 0.0
        }
    }
    
    private func addToHistory(_ result: DetectionResult) {
        // block spam
        if let last = detectionHistory.first, 
           last.label == result.label, 
           Date().timeIntervalSince(last.timestamp) < 5.0 {
            return
        }
        
        let item = DetectionHistoryItem(from: result)
        detectionHistory.insert(item, at: 0)
        
        if detectionHistory.count > 20 {
            detectionHistory = Array(detectionHistory.prefix(20))
        }
    }
    
    // MARK: - Controls
    func toggleDetection() {
        isScanning.toggle()
        if !isScanning {
            DispatchQueue.main.async {
                self.currentDetection = nil
                self.resetScanning()
            }
        }
    }
    
    func setScanning(_ state: Bool) {
        isScanning = state
        if !state {
            DispatchQueue.main.async {
                self.resetScanning()
            }
        }
    }
    
    func clearHistory() { detectionHistory.removeAll() }
    func dismissCurrentDetection() { currentDetection = nil }
}
