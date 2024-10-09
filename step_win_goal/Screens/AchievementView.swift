import SwiftUI

struct AchievementView: View {
    
    @ObservedObject var viewModel = AchivmentViewModel()

    var body: some View {
        Text(String(localized: "Achievements"))
            .multilineTextAlignment(.leading)
            .font(.system(size: 20, weight: .bold))
        VStack {
            HStack {
                VStack {
                    AchivmentImage(backgroundImage: Image("unknown1"),
                                   overlayImage: Image("running_shoe"))
                    Text(String(localized: "Steps completed2"))
                        .font(.system(size: 16, weight: .bold))
                        .padding(.bottom, 4)
                    Text("\(Int(viewModel.achivmentsSteps)) шагов")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("LightGrey"))
                        .padding(.bottom, 16)
                }
                .background(Color("DarkGrey"))
                .cornerRadius(14)
                
                VStack {
                    AchivmentImage(backgroundImage: Image("unknown1"),
                                   overlayImage: Image("routing"))
                    Text(String(localized: "Kilometers"))
                        .font(.system(size: 16, weight: .bold))
                        .padding(.bottom, 4)
                    Text("\(Int(viewModel.achivmentDistance)) километров")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("LightGrey"))
                        .padding(.bottom, 16)
                }
                .background(Color("DarkGrey"))
                .cornerRadius(14)
            }
            
            HStack {
                VStack {
                    AchivmentImage(backgroundImage: Image("unknown1"),
                                   overlayImage: Image("timer"))
                    Text("Активность")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.bottom, 4)
                    Text("\(Int(viewModel.achivmentActiveTime)) минут")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("LightGrey"))
                        .padding(.bottom, 16)
                }
                .background(Color("DarkGrey"))
                .cornerRadius(14)
                
                VStack {
                    AchivmentImage(backgroundImage: Image("unknown1"),
                                   overlayImage: Image("fire"))
                    Text("Калории")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.bottom, 4)
                    Text("\(Int(viewModel.achivmentCalories)) калорий")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("LightGrey"))
                        .padding(.bottom, 16)
                }
                .background(Color("DarkGrey"))
                .cornerRadius(14)
            }
        }
        .onAppear() {
            viewModel.fetchHealthData()
        }
    }
}
