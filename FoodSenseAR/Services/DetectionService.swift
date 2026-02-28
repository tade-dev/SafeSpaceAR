//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 14/02/2026.
//


import Foundation
import CoreML
import Vision
import CoreVideo

enum DetectionError: LocalizedError {
    case modelNotFound
    case modelLoadingFailed
    case visionModelCreationFailed
    case requestFailed
    case invalidImage
    
    var errorDescription: String? {
        switch self {
        case .modelNotFound:
            return "The CoreML model file was not found in the app bundle."
        case .modelLoadingFailed:
            return "Failed to load the CoreML model."
        case .visionModelCreationFailed:
            return "Failed to create VNCoreMLModel from the loaded MLModel."
        case .requestFailed:
            return "The Vision classification request failed."
        case .invalidImage:
            return "The provided CVPixelBuffer is invalid."
        }
    }
}

class DetectionService {
    private var visionModel: VNCoreMLModel?
    private let confidenceThreshold: Float = 0.99
    
    init() throws {
        // load compiled ML model
        guard let modelURL = Bundle.main.url(forResource: "SafeSpaceClassifier", withExtension: "mlmodelc") else {
            throw DetectionError.modelNotFound
        }
        
        do {
            let model = try MLModel(contentsOf: modelURL)
            self.visionModel = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to load CoreML model: \(error)")
            throw DetectionError.modelLoadingFailed
        }
    }
    
    // run prediction

    func performClassification(
        on pixelBuffer: CVPixelBuffer,
        completion: @escaping (Result<DetectionResult?, Error>) -> Void
    ) {
        guard let visionModel = self.visionModel else {
            completion(.failure(DetectionError.visionModelCreationFailed))
            return
        }
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(.failure(DetectionError.requestFailed))
                return
            }
            
            let label = topResult.identifier
            let confidence = topResult.confidence
            
            let validClasses = [
                "scissors",
                "knives",
                "matches_lighters",
                "glass_bottles",
                "hot_appliances",
                "plastic_bags",
                "electrical_outlets_cables",
                "liquid_chemical_hazards"
            ]
            
            // filter out low confidence
            guard confidence >= self.confidenceThreshold, validClasses.contains(label) else {
                completion(.success(nil))
                return
            }
            
            let result = DetectionResult(
                label: label,
                confidence: confidence
            )
            
            completion(.success(result))
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
}
