import Foundation

class AchivmentViewModel: ObservableObject {
    
    @Published var achivmentsSteps: Double = 0
    @Published var achivmentCalories: Double = 0
    @Published var achivmentDistance: Double = 0
    @Published var achivmentActiveTime: Double = 0
    
    func fetchHealthData() {
        HealthKitManager.shared.requestAuthorization { [weak self] success in
            guard let self = self else { return }
            if success {
                Task {
                    await self.fetchSteps()
                    await self.fetchCalories()
                    await self.fetchDistance()
                    await self.fetchActiveMinutes()
                }
            }
        }
    }
    
    private func fetchDistance() async {
        let meters = await HealthKitManager.shared.fetchDistance()
        achivmentDistance = meters / 1000
    }
    
    private func fetchSteps() async {
        let steps = await HealthKitManager.shared.fetchStepCount()
        achivmentsSteps = steps
    }
    
    private func fetchCalories() async {
        let calories = await HealthKitManager.shared.fetchCalories()
        achivmentCalories = calories
    }
    
    private func fetchActiveMinutes() async {
        let minutes = await HealthKitManager.shared.fetchActiveMinutes()
        achivmentActiveTime = minutes
    }
}
