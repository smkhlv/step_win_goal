import SwiftUI
import SwiftUICharts

struct HistoryView: View {
    
    @ObservedObject var viewModel = HistoryViewModel()
    @State private var selectedTab: StatisticType = .day
    var tabs: [StatisticType] = [.day, .week, .month, .year]

    var body: some View {
        VStack(alignment: .center) {
            Text(String(localized: "ActivityHistory"))
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .bold))
            
            Picker("", selection: $selectedTab) {
                ForEach(tabs, id: \.self) {
                    Text($0.name)
                }
            }
            .onChange(of: selectedTab) { tab in
                viewModel.getSteps(by: tab)
                viewModel.getCalories(by: tab)
                viewModel.getDistance(by: tab)
            }
            
            .pickerStyle(.segmented)
            
            VStack {
                HStack {
                    Text(String(localized: "Steps"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                    Spacer()
                    Text("\(Int(viewModel.steps.reduce(0, { $0 + $1.endValue })))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                }
                BarChartView(
                    dataPoints: viewModel.steps
                )
                .chartStyle(BarChartStyle(showAxis: true, showLabels: false, showLegends: false))
                .padding(16)
            }
            .background(Color("DarkGrey"))
            .cornerRadius(14)
            .frame(height: 155)
            .padding(16)

            VStack {
                HStack {
                    Text(String(localized: "Calories"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                    Spacer()
                    Text("\(Int(viewModel.calories.reduce(0, { $0 + $1.endValue })))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                }
                BarChartView(
                    dataPoints: viewModel.calories
                )
                .chartStyle(BarChartStyle(showAxis: true, showLabels: false, showLegends: false))
                .padding(16)
            }
            .background(Color("DarkGrey"))
            .cornerRadius(14)
            .frame(height: 155)
            .padding(16)
            
            VStack {
                HStack {
                    Text(String(localized: "Kilometers"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                    Spacer()
                    Text("\(Int(viewModel.distance.reduce(0, { $0 + $1.endValue })))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .leading, .trailing], 16)
                }
                BarChartView(
                    dataPoints: viewModel.distance
                )
                .chartStyle(BarChartStyle(showAxis: true, showLabels: false, showLegends: false))
                .padding(16)
            }
            .background(Color("DarkGrey"))
            .cornerRadius(14)
            .frame(height: 155)
            .padding(16)
        }
        Spacer()
            .onAppear() {
                viewModel.getSteps(by: .day)
                viewModel.getCalories(by: .day)
                viewModel.getDistance(by: .day)
            }
    }
}
