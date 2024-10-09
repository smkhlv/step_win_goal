import SwiftUI

struct ActivityRing: View {
    @Binding var progress: CGFloat// Progress value between 0 and 1
    var color: Color
    var lineWidth: CGFloat = 15
    
    var body: some View {
        Circle()
            .stroke(lineWidth: lineWidth)
            .opacity(0.3)
            .foregroundColor(.gray)
        
        Circle()
            .trim(from: 0.0, to: progress)
            .stroke(color,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
            )
            .rotationEffect(Angle(degrees: 270.0))
            .animation(.linear(duration: 1.0), value: progress)
    }
}

struct ActivitySummaryView: View {
    @ObservedObject var viewModel = ActivityViewModel()
    @FormattedDate var currentDate: String
    
    @State var shouldShowCirculars = true
    
    // State to hold progress for animations
    @State private var progressDistanceRing: CGFloat = 0
    @State private var progressCaloryRing: CGFloat = 0
    @State private var progressActiveMinutesRing: CGFloat = 0

    private var headerTitle: String {
       return !self.isFocused ? String(localized: "SummaryOfActivity") : String(localized: "SetTheValue")
    }
    
    private var stepsLabel: String {
       return !self.isFocused ? String(localized: "StepsCompleted"): String(localized: "StepsPerDay")
    }
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            VStack {
                Text(currentDate)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(headerTitle)
                    .font(.title2)
                    .bold()
            }
            .padding(.top)
            if shouldShowCirculars {
                ZStack {
                    // Кольца активности
                    ActivityRing(progress: $progressDistanceRing, color: .blue)
                        .frame(width: 200, height: 200)

                    ActivityRing(progress: $progressCaloryRing, color: .orange)
                        .frame(width: 160, height: 160)

                    ActivityRing(progress: $progressActiveMinutesRing, color: .gray)
                        .frame(width: 120, height: 120)

                    Image("running_shoe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .padding()
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }

            TextField("10000", value: $viewModel.stepCount, format: .number)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .disabled(shouldShowCirculars)
                .focused($isFocused)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .onChange(of: isFocused) { focused in
                    if !focused {
                        // Когда клавиатура скрыта (ввод завершён), обновляем шаги в модели
                        viewModel.state = .observeStepCount
                    } else {
                        viewModel.state = .observeGoal
                    }
                }
                .onChange(of: viewModel.stepCount) { newValue in
                    if viewModel.state == .observeGoal {
                        viewModel.changeStepsGoal(value: "\(Int(viewModel.stepCount))")
                    }
                }
            
            Text(stepsLabel)
                .font(.system(size: 29))
                .foregroundColor(.gray)

            HStack {
                // Калории
                VStack {
                    Image("fire")
                        .frame(width: 52, height: 52, alignment: .center)
                        .background(.blue)
                        .cornerRadius(10)
                    Text("\(Int(viewModel.caloriesBurned))")
                        .font(.title)
                        .foregroundColor(.white)
                    Text(String(localized: "Calories"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Километры
                VStack {
                    Image("routing")
                        .frame(width: 52, height: 52, alignment: .center)
                        .background(.gray)
                        .cornerRadius(10)
                    Text(String(format: "%.2f", viewModel.distance))
                        .font(.title)
                        .foregroundColor(.white)
                    Text(String(localized: "Kilometers"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Время активности
                VStack {
                    Image("timer")
                        .frame(width: 52, height: 52, alignment: .center)
                        .background(.orange)
                        .cornerRadius(10)
                    
                    Text("\(Int(viewModel.activeMinutes))")
                        .font(.title)
                        .foregroundColor(.white)
                    Text(String(localized: "Minutes"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            Spacer()
            
            Button(action: {
                // Действие кнопки
                withAnimation {
                    shouldShowCirculars.toggle()
                    isFocused = !shouldShowCirculars
                }
                
                // When returning to rings, reanimate their appearance
                if shouldShowCirculars {
                    progressDistanceRing = viewModel.progressDistanceRing
                    progressCaloryRing = viewModel.progressCaloryRing
                    progressActiveMinutesRing = viewModel.progressActiveMinutesRing
                }
                
            }) {
                Text(String(localized: "SetAgoal"))
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding([.bottom, .leading, .trailing], 16)
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear() {
            viewModel.fetchHealthData {
                withAnimation(.easeInOut(duration: 1.0)) {
                    progressDistanceRing = viewModel.progressDistanceRing
                    progressCaloryRing = viewModel.progressCaloryRing
                    progressActiveMinutesRing = viewModel.progressActiveMinutesRing
                }
            }
        }
    }
}

//#Preview {
//    ActivitySummaryView()
//}
