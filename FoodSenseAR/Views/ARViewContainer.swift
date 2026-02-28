//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 15/02/2026.
//


import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        
        arView.session.run(context.coordinator.configuration)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if context.coordinator.wasScanning != arViewModel.isScanning {
            context.coordinator.wasScanning = arViewModel.isScanning
            
            if arViewModel.isScanning {
                uiView.session.run(context.coordinator.configuration, options: [])
            } else {
                uiView.session.pause()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainer
        let configuration: ARWorldTrackingConfiguration
        var wasScanning: Bool = true
        
        private var detectionService: DetectionService?
        private var lastDetectionTime: TimeInterval = 0
        private let detectionInterval: TimeInterval = 0.5
        // Keep vision tracking off main thread to prevent lag
        private let processingQueue = DispatchQueue(label: "com.safespace.processing", qos: .userInitiated)
        
        private var isProcessingFrame = false
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
            
            self.configuration = ARWorldTrackingConfiguration()
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                self.configuration.frameSemantics.insert(.sceneDepth)
            }
            
            super.init()
            
            do {
                self.detectionService = try DetectionService()
            } catch {
                print("Failed to initialize DetectionService: \(error.localizedDescription)")
            }
        }
        
        // MARK: - ARSCNViewDelegate
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard parent.arViewModel.isScanning else { return }
            
            guard time - lastDetectionTime >= detectionInterval else { return }
            
            guard !isProcessingFrame else { return }
            
            guard let arView = renderer as? ARSCNView,
                  let currentFrame = arView.session.currentFrame else { return }
            
            let pixelBuffer = currentFrame.capturedImage
            
            lastDetectionTime = time
            isProcessingFrame = true
            
            processingQueue.async { [weak self] in
                guard let self = self else { return }
                
                self.detectionService?.performClassification(on: pixelBuffer) { result in
                    defer {
                        self.isProcessingFrame = false
                    }
                    
                    switch result {
                    case .success(let detectionResult):
                        self.parent.arViewModel.updateDetection(detectionResult)
                        
                    case .failure(let error):
                        print("Classification Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
