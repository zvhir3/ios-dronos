

import SwiftUI
struct Mission: Identifiable {
    let id = UUID()
    let missionId: String
    let name: String
    let location: String
    let schedules: [Schedule]
    
    init(from serviceMission: APIService.Mission) {
        self.missionId = serviceMission.missionId
        self.name = serviceMission.name
        self.location = serviceMission.location
        self.schedules = serviceMission.schedules.map(Schedule.init(from:))
    }
    
    var status: String {
        let formatter = ISO8601DateFormatter()
        
        let startDate = formatter.date(from: schedules.first?.startDate ?? "") ?? Date()
        let endDate = formatter.date(from: schedules.first?.endDate ?? "") ?? Date()
        
        let currentTime = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: formatDateTime(schedules.first?.startTime ?? 0))
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: formatDateTime(schedules.first?.endTime ?? 0))
        
        let today = Date()
        
        if today > endDate {
            return "Completed"
        } else if today < startDate {
            return "Scheduled"
        } else if today < endDate && today > startDate && currentTime.hour! > startTime.hour! && currentTime.minute! > startTime.minute! && currentTime.hour! < endTime.hour! && currentTime.minute! < endTime.minute! {
            return "Active"
        } else {
            return "Unknown"
        }
    }
}

struct Schedule: Hashable {
    let startDate: String
    let startTime: Int
    let endDate: String
    let endTime: Int
    
    init(from serviceSchedule: APIService.Schedule) {
        self.startDate = serviceSchedule.startDate
        self.startTime = serviceSchedule.startTime
        self.endDate = serviceSchedule.endDate
        self.endTime = serviceSchedule.endTime
    }
}

struct Area: Hashable {
    let coordinate: [Coordinate]
}

struct Coordinate: Hashable {
    let latitude: String
    let longitude: String
}

class MissionsViewModel: ObservableObject {
    @Published var missions: [Mission] = []
//    @State private var isEmptyMission: Bool = false
    
    
    
    
    func fetchMissions() {
        
        APIService.fetchMissions { serviceMissions in
            DispatchQueue.main.async {
               
                    self.missions = serviceMissions.map(Mission.init(from:))
            }
        }
        
    }
}

struct MissionsView: View {
    @StateObject private var viewModel = MissionsViewModel()
    @State private var searchMission: String = ""
    @State private var date = Date()
    @State private var showingDatePicker: Bool = false
//    @State private var isEmptyMission: Bool = false
    
    init() {
        UINavigationBar.appearance().backgroundColor = .clear
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 56 / 255, green: 65 / 255, blue: 76 / 255, opacity: 1)
                VStack(spacing: 20) {
                    HStack() {
                        Image("chevron-back")
                            .frame(height: 24)
                        //                            .padding(.horizontal, 10)
                        Text("Mission List")
                            .font(.system(size: 17, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal, 98)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .frame(width: 390, alignment: .leading)
                    
                    HStack() {
                        HStack {
                            Image("search-icon") // SF Symbol for a magnifying glass
                                .resizable() // Add this
                                .frame(width: 24, height: 24) // Specify the size you want here
                                .foregroundColor(.white)
                                .padding(.horizontal, 10) // Position the icon
                            
                            TextField("Search Mission Name", text: $searchMission)
                                .foregroundColor(Color.white)
                                .frame(width: .infinity, height: 50, alignment: .leading)
                        }
                        //                        .background(Color(UIColor.fromHex(0x879AA6)))
                        .background(.white.opacity(0.1))
                        .cornerRadius(10)
//                        .padding(.horizontal, 5)
                        .padding(.vertical, 25)
                        
                        VStack(alignment: .center, spacing: 8) {
                            
                        }
                        .padding(0)
                        .frame(width: 50, height: 48, alignment: .center)
                        .background(.white.opacity(0.1))
                        .cornerRadius(4)
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 1, y: 1)
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .inset(by: 0.29)
                                    .stroke(.white.opacity(0.1), lineWidth: 0.58)
                                
                                Image("filter-icon") // SF Symbol for a magnifying glass
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                            }
                        )
                    }
                    
                    .padding(.horizontal, 20)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .top)
                    ScrollView {
                        
                            
                        if viewModel.missions.isEmpty {
                            Text("No Mission available")
                                .italic()
                                .font(.system(size: 22))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ForEach(viewModel.missions) { mission in
//                                NavigationLink(destination: DenseContentSheetViewController(mission: mission).transition(.move(edge: .trailing))
//                                    .animation(.easeInOut(duration: 0.5), value: true)) {
                                        ZStack(alignment: .top) {
                                            MissionCardView(mission: mission)
                                                .padding(.bottom, 10)
                                                .padding(.horizontal, 20)
                                            VStack(spacing: -32) {
                                                HStack {
                                                    Spacer().frame(width: UIScreen.main.bounds.width / 1.35)
                                                    HStack {
                                                        Text(mission.status)
                                                            .font(.system(size: 8))
                                                            .kerning(0.4)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(Color(red: 0.4, green: 0.84, blue: 0.65))
                                                            .textCase(.uppercase)
                                                    }
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 2)
                                                    .background(Color(red: 0.4, green: 0.84, blue: 0.65).opacity(0.2))
                                                    .clipShape(RoundedCorners(topLeft: 4, bottomLeft: 4))
                                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                                }
                                                .padding(.top, 10)
                                                HStack {
                                                    Spacer().frame(width: UIScreen.main.bounds.width / 1.10)
                                                    // Add the image here
                                                    Image("status-img")
                                                        .resizable() // Add this if your image is not appearing
                                                }
                                            }
                                        }
//                                    }
//                                    .background(Color.clear)
                            }
                        }

                    }
                    //                        }
                }
                .padding(.top, 90)
                .foregroundColor(.white)
                
            }.ignoresSafeArea(.all)
                .onAppear {
                    viewModel.fetchMissions()
                }
                .navigationBarHidden(false)
        }
    }
}


struct MissionCardView: View {
    let mission: Mission
    var body: some View {
        //        ZStack {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 4) {
                Text(mission.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                
                Image("dot")
                    .resizable() // Add this
                    .frame(width: 5, height: 5)
                
                Text(mission.missionId)
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(mission.location)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            ForEach(mission.schedules, id: \.self) { schedule in
                Text("\(formatTime(schedule.startTime)) - \(formatTime(schedule.endTime))")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.69, green: 0.75, blue: 0.77))
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 20)
        .padding(.vertical, 12)
        .frame(width: .infinity, alignment: .topLeading)
        .background(Color(red: 0.22, green: 0.25, blue: 0.3).opacity(0.8))
        .background(.white.opacity(0.05))
        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 11)
    }
}

//struct MissionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MissionsView()
//    }
//}
