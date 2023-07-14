import UIKit

class Missions: UIViewController {
    
    struct Mission: Decodable {
        let missionId: String
        let name: String
        let schedules: [Schedule]
    }
    
    struct Schedule: Decodable {
        let startDate: String?
        let endDate: String
        let startTime: Int
        let endTime: Int
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
           
        
        // Set the title of the view controller
        title = "Missions"
        
        // Customize the appearance of the navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.fromHex(0x1e293b)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        
        // Create the red view for the bottom safe area
        let bottomSafeAreaView = UIView()
        bottomSafeAreaView.backgroundColor = UIColor.red
        
        // Add the red view to the main window
        view.addSubview(bottomSafeAreaView)
        bottomSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSafeAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomSafeAreaView.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
       }

      
      private func setupUI() {
          // Set the background color
          view.backgroundColor = UIColor.fromHex(0x14181f)
          
          // Create and configure the title label
          let titleLabel = UILabel()
          titleLabel.text = "Today's Missions"
          titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
          titleLabel.translatesAutoresizingMaskIntoConstraints = false
          
          // Add the views to the main view
          view.addSubview(scrollView)
          scrollView.addSubview(titleLabel)
          scrollView.addSubview(stackView)
          
          // Set up constraints
          NSLayoutConstraint.activate([
              scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              
              titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
              titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
              stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
              stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
              stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
              stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
          ])
      }
    private func fetchMissions() {
        guard let url = URL(string: "https://dev-api.dronos.ai/mission/missions/") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("Error fetching missions: \(error)")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Extract the "records" array from the JSON
                guard let records = jsonData["records"] as? [[String: Any]] else {
                    print("Error extracting 'records' from the JSON")
                    return
                }
                
                // Decode each mission object from the records array
                let missions = try records.map { record -> Mission in
                    let missionId = record["missionId"] as? String ?? ""
                    let name = record["name"] as? String ?? ""
                    
                    // Extract the "schedules" dictionary from the record
                    guard let schedulesDict = record["schedules"] as? [String: Any] else {
                        print("Error extracting 'schedules' from the record")
                        print(record["schedules"])
                        return Mission(missionId: missionId, name: name, schedules: [])
                    }
                    
                    // Decode the schedules array from the schedules dictionary
                    let schedulesData = try JSONSerialization.data(withJSONObject: schedulesDict, options: [])
                    let schedules = try decoder.decode([Schedule].self, from: schedulesData)
                    
                    return Mission(missionId: missionId, name: name, schedules: schedules)
                }
                
                DispatchQueue.main.async {
                    for mission in missions {
                        let cardView = self?.createCardView(mission: mission)
                        self?.stackView.addArrangedSubview(cardView!)
                        
                        // Add tap gesture recognizer to the card
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self?.cardTapped(_:)))
                        cardView?.addGestureRecognizer(tapGestureRecognizer)
                    }
                }
            } catch {
                print("Error decoding mission data: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func createCardView(mission: Mission) -> UIView {
        // Create the card view
        let cardView = UIView()
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true // Enable user interaction for tap gesture recognizer
        cardView.backgroundColor = UIColor.fromHex(0x1e293b)
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.fromHex(0x00f0ff).cgColor // Set shadow color to cyan
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true // Enable user interaction for tap gesture recognizer

        
        // Create and configure the missionId label
        let missionIdLabel = UILabel()
        missionIdLabel.text = "\(mission.missionId)"
        missionIdLabel.font = UIFont(name: "Barlow-SemiBold", size: 14)
        missionIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the name label
        let nameLabel = UILabel()
        nameLabel.text = "Name: \(mission.name)"
        nameLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the schedule label
        let scheduleLabel = UILabel()
        if let startDate = mission.schedules.first?.startDate {
            scheduleLabel.text = "Schedule: \(startDate) - \(mission.schedules.first?.endDate ?? "")"
            scheduleLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        } else {
            scheduleLabel.text = "Schedule: N/A"
            scheduleLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        }
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the subviews to the card view
        cardView.addSubview(missionIdLabel)
        cardView.addSubview(nameLabel)
        cardView.addSubview(scheduleLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            missionIdLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            missionIdLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: missionIdLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            scheduleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            scheduleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            scheduleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        // Handle card tapped event
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
           
           // Instantiate the view controller from the main storyboard
           if let mainViewController = storyboard.instantiateInitialViewController() {
               // Present the view controller
               present(mainViewController, animated: true, completion: nil)
           }
    }
}
