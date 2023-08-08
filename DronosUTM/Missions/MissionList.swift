//import UIKit
//
//class Missions: UIViewController {
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        fetchMissions()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        title = "Missions"
//
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.fromHex(0x1e293b)
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().backIndicatorImage = UIImage()
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
//
//        let bottomSafeAreaView = UIView()
//        bottomSafeAreaView.backgroundColor = UIColor.red
//
//        view.addSubview(bottomSafeAreaView)
//        bottomSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            bottomSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomSafeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bottomSafeAreaView.topAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    private func fetchMissions() {
//        APIService.fetchMissions { [weak self] missions in
//            DispatchQueue.main.async {
//                for mission in missions {
//                    let cardView = self?.createCardView(mission: mission)
//                    if let cardView = cardView {
//                        self?.stackView.addArrangedSubview(cardView)
//                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self?.cardTapped(_:)))
//                        cardView.addGestureRecognizer(tapGestureRecognizer)
//                    }
//                }
//            }
//        }
//    }
//
//    private func setupUI() {
//        view.backgroundColor = UIColor.fromHex(0x14181f)
////        view.backgroundColor = UIColor(red: 34/255.0, green: 38/255.0, blue: 50/255.0, alpha: 0.8)
//
//        let titleLabel = UILabel.makeTitleLabel(text: "Mission List")
////        let connectedDroneLabel = UILabel.makeConnectedDroneLabel(text: "Connected Drone: -")
//
//        view.addSubview(scrollView)
////        scrollView.addSubview(connectedDroneLabel)
//        scrollView.addSubview(titleLabel)
//        scrollView.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
//        ])
//    }
//
//
//    private func createCardView(mission: APIService.Mission) -> UIView {
//
//        let scheduleText = mission.schedules.map { schedule in
//            return "Start Date: \(schedule.startDate)\(schedule.startTime) End Date: \(schedule.endDate) \(schedule.endTime)"
//        }.joined(separator: "\n")
//
//        let coordinateText = mission.area.coordinate.map { coordinate in
//            return "Coordinate: \(coordinate.latitudeDouble),\(coordinate.longitudeDouble)"
//        }.joined(separator: "")
//
//        let missionIdLabel = UILabel.makeLabel(text: "\(mission.missionId)", textColor: UIColor.fromHex(0xffffff))
//        let nameLabel = UILabel.makeLabel(text: "Name: \(mission.name)", textColor: UIColor.fromHex(0xffffff))
//        let locationLabel = UILabel.makeLabel(text: "Location: \(mission.location)", textColor: UIColor.fromHex(0xffffff))
//        let scheduleLabel = UILabel.makeLabel(text: "\(scheduleText)", textColor: UIColor.fromHex(0xffffff))
//        let coordinateLabel = UILabel.makeLabel(text: "Coordinate: \(coordinateText)", textColor: UIColor.fromHex(0xffffff))
//
//        coordinateLabel.translatesAutoresizingMaskIntoConstraints = false
//        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let cardView = UIView()
//        cardView.backgroundColor = .lightGray
//        cardView.layer.cornerRadius = 8
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        cardView.isUserInteractionEnabled = true
//        cardView.backgroundColor = UIColor.fromHex(0x1e293b)
//        cardView.layer.cornerRadius = 8
//        cardView.layer.shadowColor = UIColor.fromHex(0x00f0ff).cgColor
//        cardView.layer.shadowRadius = 2
//        cardView.layer.shadowOpacity = 1
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        cardView.isUserInteractionEnabled = true
//        cardView.addSubview(missionIdLabel)
//        cardView.addSubview(nameLabel)
//        cardView.addSubview(locationLabel)
//        cardView.addSubview(coordinateLabel)
//        cardView.addSubview(scheduleLabel)
//
//        NSLayoutConstraint.activate([
//            missionIdLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
//            missionIdLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            nameLabel.topAnchor.constraint(equalTo: missionIdLabel.bottomAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            locationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            coordinateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
//            coordinateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            scheduleLabel.topAnchor.constraint(equalTo: coordinateLabel.bottomAnchor, constant: 8),
//            scheduleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//            scheduleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
//        ])
//
//        return cardView
//    }
//
//    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        if let mainViewController = storyboard.instantiateInitialViewController() {
////            present(mainViewController, animated: true, completion: nil)
////        }
//    }
//}
//

import SwiftUI

struct Mission: Identifiable {
    let id = UUID()
    let missionId: Int
    let name: String
    let location: String
    let schedules: [Schedule]
}

struct Schedule: Hashable {
    let startDate: String
    let startTime: String
    let endDate: String
    let endTime: String
}

class MissionsViewModel: ObservableObject {
    @Published var missions: [Mission] = []
    
    
    
    func fetchMissions() {
        // Implement your logic to fetch missions here
        // For demonstration purposes, let's use some dummy data
        let dummyMissions = [
            Mission(missionId: 1, name: "Mission 1", location: "Location 1", schedules: []),
            Mission(missionId: 2, name: "Mission 2", location: "Location 2", schedules: [])
        ]
        missions = dummyMissions
    }
}

struct MissionsView: View {
    @StateObject private var viewModel = MissionsViewModel()
    @State private var searchMission: String = ""
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
                        .padding(.horizontal, 5)
                        .padding(.vertical, 25)
                        
                        VStack(alignment: .center, spacing: 8) { }
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
                                        .resizable() // Add this
                                        .frame(width: 20, height: 20) // Specify the size you want here
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                    
                                }
                            )
                    }
                    
                    .padding(.horizontal, 24)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                    NavigationView {
                        ScrollView {
                            ForEach(viewModel.missions) { mission in
                                NavigationLink(destination: Launchpad().transition(.move(edge: .trailing))
                                    .animation(.easeInOut(duration: 0.5), value: true)) {
                                    MissionCardView(mission: mission)
                                }
                            }
                        }
                        }
                    }
                    .padding(.top, 90)
                    .foregroundColor(.white)
                    
                }.ignoresSafeArea(.all)
                
                //            .background(Color(red: 34/255.0, green: 38/255.0, blue: 50/255.0, opacity: 0.8))
                //            .ignoresSafeArea()
                //            .frame(width: 900)
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Mission ID: \(mission.missionId)")
                Text("Name: \(mission.name)")
                Text("Location: \(mission.location)")
                ForEach(mission.schedules, id: \.self) { schedule in
                    Text("Start Date: \(schedule.startDate) \(schedule.startTime)")
                    Text("End Date: \(schedule.endDate) \(schedule.endTime)")
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            .shadow(color: Color.blue, radius: 2, x: 0, y: 0)
            .padding(.horizontal)
        }
    }
    
    struct MissionsView_Previews: PreviewProvider {
        static var previews: some View {
            MissionsView()
        }
    }
