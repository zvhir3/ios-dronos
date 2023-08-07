import UIKit

class Missions: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMissions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Missions"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.fromHex(0x1e293b)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        
        let bottomSafeAreaView = UIView()
        bottomSafeAreaView.backgroundColor = UIColor.red
        
        view.addSubview(bottomSafeAreaView)
        bottomSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSafeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSafeAreaView.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchMissions() {
        APIService.fetchMissions { [weak self] missions in
            DispatchQueue.main.async {
                for mission in missions {
                    let cardView = self?.createCardView(mission: mission)
                    if let cardView = cardView {
                        self?.stackView.addArrangedSubview(cardView)
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self?.cardTapped(_:)))
                        cardView.addGestureRecognizer(tapGestureRecognizer)
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.fromHex(0x14181f)
        
        let titleLabel = UILabel.makeTitleLabel(text: "Today's Missions")
        let connectedDroneLabel = UILabel.makeConnectedDroneLabel(text: "Connected Drone: -")
        
        view.addSubview(scrollView)
        scrollView.addSubview(connectedDroneLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            connectedDroneLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            connectedDroneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: connectedDroneLabel.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func createCardView(mission: APIService.Mission) -> UIView {
        
        let scheduleText = mission.schedules.map { schedule in
            return "Start Date: \(schedule.startDate)\(schedule.startTime) End Date: \(schedule.endDate) \(schedule.endTime)"
        }.joined(separator: "\n")

        let coordinateText = mission.area.coordinate.map { coordinate in
            return "Coordinate: \(coordinate.latitudeDouble),\(coordinate.longitudeDouble)"
        }.joined(separator: "")
        
        let missionIdLabel = UILabel.makeLabel(text: "\(mission.missionId)", textColor: UIColor.fromHex(0xffffff))
        let nameLabel = UILabel.makeLabel(text: "Name: \(mission.name)", textColor: UIColor.fromHex(0xffffff))
        let locationLabel = UILabel.makeLabel(text: "Location: \(mission.location)", textColor: UIColor.fromHex(0xffffff))
        let scheduleLabel = UILabel.makeLabel(text: "\(scheduleText)", textColor: UIColor.fromHex(0xffffff))
        let coordinateLabel = UILabel.makeLabel(text: "Coordinate: \(coordinateText)", textColor: UIColor.fromHex(0xffffff))
        
        coordinateLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = UIView()
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true
        cardView.backgroundColor = UIColor.fromHex(0x1e293b)
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.fromHex(0x00f0ff).cgColor
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true
        cardView.addSubview(missionIdLabel)
        cardView.addSubview(nameLabel)
        cardView.addSubview(locationLabel)
        cardView.addSubview(coordinateLabel)
        cardView.addSubview(scheduleLabel)
        
        NSLayoutConstraint.activate([
            missionIdLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            missionIdLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: missionIdLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            coordinateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            coordinateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            scheduleLabel.topAnchor.constraint(equalTo: coordinateLabel.bottomAnchor, constant: 8),
            scheduleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            scheduleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let mainViewController = storyboard.instantiateInitialViewController() {
//            present(mainViewController, animated: true, completion: nil)
//        }
    }
}
