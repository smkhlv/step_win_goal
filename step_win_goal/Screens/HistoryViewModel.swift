import Foundation
import SwiftUICharts

enum StatisticType {
    case day, week, month, year
    
    var name: String {
        switch self {
        case .day:
            String(localized: "Day")
        case .week:
            String(localized: "Week")
        case .month:
            String(localized: "Month")
        case .year:
            String(localized: "Year")
        }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var steps: [DataPoint] = []
    @Published var calories: [DataPoint] = []
    @Published var distance: [DataPoint] = []
    
    @MainActor func getSteps(by: StatisticType) {
        Task {
            switch by {
            case .day:
                let steps = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchStepsData(by: .day) { continuation.resume(returning: $0) }
                }
                self.steps = steps
            case .week:
                let steps = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchStepsData(by: .weekOfMonth) { continuation.resume(returning: $0) }
                }
                self.steps = steps
            case .month:
                let steps = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchStepsData(by: .month) { continuation.resume(returning: $0) }
                }
                self.steps = steps
            case .year:
                let steps = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchStepsData(by: .year) { continuation.resume(returning: $0) }
                }
                self.steps = steps
            }
        }
    }
    
    @MainActor func getCalories(by: StatisticType) {
        Task {
            switch by {
            case .day:
                let calories = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchCaloriesData(by: .day) { continuation.resume(returning: $0) }
                }
                self.calories = calories
            case .week:
                let calories = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchCaloriesData(by: .weekOfMonth) { continuation.resume(returning: $0) }
                }
                self.calories = calories
            case .month:
                let calories = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchCaloriesData(by: .month) { continuation.resume(returning: $0) }
                }
                self.calories = calories
            case .year:
                let calories = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchCaloriesData(by: .year) { continuation.resume(returning: $0) }
                }
                self.calories = calories
            }
        }
    }
    
    @MainActor func getDistance(by: StatisticType) {
        Task {
            switch by {
            case .day:
                let distance = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchDistanceData(by: .day) { continuation.resume(returning: $0) }
                }
                self.distance = distance
            case .week:
                let distance = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchDistanceData(by: .weekOfMonth) { continuation.resume(returning: $0) }
                }
                self.distance = distance
            case .month:
                let distance = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchDistanceData(by: .month) { continuation.resume(returning: $0) }
                }
                self.distance = distance
            case .year:
                let distance = await withCheckedContinuation { continuation in
                    HealthKitManager.shared.fetchDistanceData(by: .year) { continuation.resume(returning: $0) }
                }
                self.distance = distance
            }
        }
    }
}
