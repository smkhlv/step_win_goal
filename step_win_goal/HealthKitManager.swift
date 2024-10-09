import Foundation
import SwiftUI
import HealthKit
import SwiftUICharts

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    // Запрашиваем разрешения на доступ к данным HealthKit
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let readTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                             HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                             HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
                             HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                             HKObjectType.activitySummaryType()])
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            completion(success)
        }
    }
    
    // Получаем количество шагов
    func fetchStepCount() async -> Double {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        return await fetchQuantitySum(for: stepType, unit: HKUnit.count())
    }
    
    // Получаем количество калорий
    func fetchCalories() async -> Double {
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        return await fetchQuantitySum(for: caloriesType, unit: HKUnit.kilocalorie())
    }
    
    func fetchDistance() async -> Double {
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        return await fetchQuantitySum(for: caloriesType, unit: HKUnit.meter())
    }
    
    // Получаем дистанцию
    func fetchActiveMinutes() async -> Double {
        let energyType = HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: today, end: now, options: .strictStartDate)

        let (_, result, error) = await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { continuation.resume(returning: ($0, $1, $2)) }
            healthStore.execute(query)
        }
        guard let result = result, let sum = result.sumQuantity() else {
            print("Failed to fetch total stand time: \(error?.localizedDescription ?? "")")
            return 0.0
        }
        return sum.doubleValue(for: HKUnit.minute())
    }
    
    // Общий метод для получения суммы данных
    private func fetchQuantitySum(for type: HKQuantityType, unit: HKUnit) async -> Double {
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let (_, result, _) = await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { continuation.resume(returning: ($0, $1, $2)) }
            healthStore.execute(query)
        }
        guard let result = result, let sum = result.sumQuantity() else {
            return 0.0
        }
        return sum.doubleValue(for: unit)
    }
    
    func fetchStepsData(by adding: Calendar.Component, completion: @escaping([DataPoint]) -> ()) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.date(byAdding: adding, value: -1, to: Date())!
        let endDate = Date()
        
        var interval = DateComponents()
        switch adding {
        case .day:
            interval.hour = 1
        case .weekday:
            interval.day = 1
        case .month:
            interval.weekOfMonth = 1
        case .year:
            interval.month = 1
        default:
            interval.day = 1
        }
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                var stepsData: [DataPoint] = []
                
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        let date = statistics.startDate
                        
                        let legend = Legend(color: .blue, label: "step")
                        let formatted = FormattedDay()
                        let localizedKey = LocalizedStringKey(formatted.format(with: date))
                        
                        stepsData.append(DataPoint(value: steps,
                                                   label: localizedKey, legend: legend))
                    }
                }
                completion(stepsData)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchCaloriesData(by adding: Calendar.Component, completion: @escaping([DataPoint]) -> ()) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let startDate = Calendar.current.date(byAdding: adding, value: -1, to: Date())!
        let endDate = Date()
        
        var interval = DateComponents()
        switch adding {
        case .day:
            interval.hour = 1
        case .weekday:
            interval.day = 1
        case .month:
            interval.weekOfMonth = 1
        case .year:
            interval.month = 1
        default:
            interval.day = 1
        }
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                var stepsData: [DataPoint] = []
                
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        let date = statistics.startDate
                        
                        let legend = Legend(color: .blue, label: "calories")
                        let formatted = FormattedDay()
                        let localizedKey = LocalizedStringKey(formatted.format(with: date))
                        
                        stepsData.append(DataPoint(value: calories,
                                                   label: localizedKey, legend: legend))
                    }
                }
                completion(stepsData)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchDistanceData(by adding: Calendar.Component, completion: @escaping([DataPoint]) -> ()) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let startDate = Calendar.current.date(byAdding: adding, value: -1, to: Date())!
        let endDate = Date()
        
        var interval = DateComponents()
        switch adding {
        case .day:
            interval.hour = 1
        case .weekday:
            interval.day = 1
        case .month:
            interval.weekOfMonth = 1
        case .year:
            interval.month = 1
        default:
            interval.day = 1
        }
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                var stepsData: [DataPoint] = []
                
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let distancies = quantity.doubleValue(for: HKUnit.meter())
                        let date = statistics.startDate
                        
                        let legend = Legend(color: .blue, label: "distance")
                        let formatted = FormattedDay()
                        let localizedKey = LocalizedStringKey(formatted.format(with: date))
                        
                        stepsData.append(DataPoint(value: distancies,
                                                   label: localizedKey, legend: legend))
                    }
                }
                completion(stepsData)
            }
        }
        
        healthStore.execute(query)
    }
}
