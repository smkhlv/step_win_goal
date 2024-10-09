import Foundation

enum ActivityViewModelState {
    case observeGoal, observeStepCount
}

class ActivityViewModel: ObservableObject {
    @Published var stepCount: Double = 0
    @Published var caloriesBurned: Double = 0
    @Published var activeMinutes: Double = 0
    @Published var distance: Double = 0

    @Published var progressCaloryRing: CGFloat = 0
    @Published var progressDistanceRing: CGFloat = 0
    @Published var progressActiveMinutesRing: CGFloat = 0
    
    private var cachedStepCount: Double = 0
    public var state: ActivityViewModelState = .observeStepCount {
        didSet {
            if state == .observeStepCount {
                stepCount = cachedStepCount
            } else {
                stepCount = goalSteps
            }
        }
    }
    public var goalSteps: Double = 10000
    public var outputTextfield: String = ""

    func changeStepsGoal(value: String) {
        self.goalSteps = Double(value) ?? 10000
        self.progressDistanceRing = min(self.cachedStepCount / self.goalSteps, 1.0)
    }
    
    func fetchHealthData(completion: @escaping () -> ()) {
        HealthKitManager.shared.requestAuthorization { [weak self] success in
            guard let self = self else { return }
            if success {
                Task {
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask { await self.fetchSteps() }
                        group.addTask { await self.fetchActiveMinutes() }
                        group.addTask { await self.fetchCalories() }
                        group.addTask { await self.fetchDistance() }
                    }   
                    completion()
                }
            }
        }
    }
    
    @MainActor private func fetchDistance() async {
        let meters = await HealthKitManager.shared.fetchDistance()
        distance = meters / 1000
    }
    
    @MainActor private func fetchSteps() async {
        let steps = await HealthKitManager.shared.fetchStepCount()
        stepCount = steps
        cachedStepCount = steps
        progressDistanceRing = min(steps / self.goalSteps, 1.0)
    }
    
    @MainActor private func fetchCalories() async {
        let calories = await HealthKitManager.shared.fetchCalories()
        caloriesBurned = calories
        progressCaloryRing = min(calories / 1000, 1.0)
    }
    
    @MainActor private func fetchActiveMinutes() async {
        let minutes = await HealthKitManager.shared.fetchActiveMinutes()
        activeMinutes = minutes
        progressActiveMinutesRing = min(minutes / 60, 1.0)
    }
}
