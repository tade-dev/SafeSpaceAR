//
//  SwiftUIView.swift
//  FoodSenseAR
//
//  Created by BSTAR on 25/02/2026.
//


import SwiftUI

enum HistoryFilter: String, CaseIterable {
    case all = "All"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .high: return DangerLevel.high.color
        case .medium: return DangerLevel.medium.color
        case .low: return DangerLevel.low.color
        }
    }
}

struct HistoryView: View {
    @EnvironmentObject var arViewModel: ARViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: HistoryFilter = .all
    
    private var filteredAndSortedHistory: [DetectionHistoryItem] {
        var items = arViewModel.detectionHistory
        
        switch selectedFilter {
        case .high: items = items.filter { $0.dangerLevel == .high }
        case .medium: items = items.filter { $0.dangerLevel == .medium }
        case .low: items = items.filter { $0.dangerLevel == .low }
        case .all: break
        }
        
        return items.sorted { item1, item2 in
            let order1 = sortOrder(for: item1.dangerLevel)
            let order2 = sortOrder(for: item2.dangerLevel)
            if order1 == order2 {
                return item1.timestamp > item2.timestamp
            }
            return order1 < order2
        }
    }
    
    private func sortOrder(for level: DangerLevel) -> Int {
        switch level {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(HistoryFilter.allCases, id: \.self) { filter in
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedFilter = filter
                                }
                            }) {
                                Text(filter.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(selectedFilter == filter ? .bold : .medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == filter ? filter.color : Color.gray.opacity(0.15))
                                    .foregroundColor(selectedFilter == filter ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(UIColor.systemBackground))
                
                Divider()
                
                List {
                    if filteredAndSortedHistory.isEmpty {
                        Text("No items match this filter.")
                            .foregroundColor(.secondary)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(filteredAndSortedHistory) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle()
                                        .fill(item.dangerLevel.color)
                                        .frame(width: 12, height: 12)
                                        
                                    Text(item.formattedLabel)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        
                                    Spacer()
                                    
                                    Text("\(Int(item.confidence * 100))%")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text(item.safetyTip)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(item.timestamp, style: .time)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(item.dangerLevel.color.opacity(0.05))
                        }
                    }
                    
                    if !arViewModel.detectionHistory.isEmpty {
                        Button(action: { arViewModel.clearHistory() }) {
                            Text("Clear History")
                        }
                        .buttonStyle(SafeSpaceButtonStyle(backgroundColor: DangerLevel.high.color.opacity(0.1), foregroundColor: DangerLevel.high.color))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.top, 16)
                    }
                }
                .listStyle(PlainListStyle())
                .animation(.spring(), value: filteredAndSortedHistory.map { $0.id })
            }
            .navigationTitle("Detection History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onAppear {
            arViewModel.setScanning(false)
        }
        .onDisappear {
            arViewModel.setScanning(true)
        }
    }
}
