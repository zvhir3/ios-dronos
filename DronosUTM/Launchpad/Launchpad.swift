import SwiftUI
import MapboxMaps

struct Launchpad: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        let viewController = ViewController()
        let missionsViewController = UIHostingController(rootView: MissionsView())
        let profilePageHostingController = UIHostingController(rootView: ProfilePage())
        
        viewController.title = "Missions"
        missionsViewController.title = "Mission"
        profilePageHostingController.title = "Profile"
        
        viewController.tabBarItem = UITabBarItem(title: "Missions", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
        missionsViewController.tabBarItem = UITabBarItem(title: "Mission", image: UIImage(systemName: "map"), tag: 1)
        profilePageHostingController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        
        tabBarController.viewControllers = [viewController, missionsViewController, profilePageHostingController]
        
        tabBarController.tabBar.barTintColor = UIColor.white // Set the background color to white
        tabBarController.tabBar.tintColor = UIColor.yellow
        
        // Set the background color to clear to make the effect view transparent
        tabBarController.tabBar.barTintColor = UIColor.black
        
        // Create a blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        // Add the blur view as the background of the tabBar
        tabBarController.tabBar.insertSubview(blurView, at: 0)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: tabBarController.tabBar.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: tabBarController.tabBar.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: tabBarController.tabBar.bottomAnchor)
        ])
        
        // Set the selected icon color to white
        tabBarController.tabBar.tintColor = UIColor.white
        
        //        // Create the floating action button
        //        let floatingActionButton = FloatingActionButton()
        //        floatingActionButton.tapHandler = {
        //            // Handle the tap event for the floating action button here
        //            print("Floating action button tapped!")
        //        }
        //
        //        // Add the floating action button to the tab bar
        //        tabBarController.tabBar.addSubview(floatingActionButton)
        //
        //        // Position the floating action button
        //        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            floatingActionButton.centerXAnchor.constraint(equalTo: tabBarController.tabBar.centerXAnchor),
        //            floatingActionButton.bottomAnchor.constraint(equalTo: tabBarController.tabBar.bottomAnchor, constant: -16)
        //        ])
        //
        //        // Adjust the button size if needed
        //        floatingActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        //        floatingActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        //
        //
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    }
}

class ViewController: UIViewController {
    private var mapView: MapView!
    private var centerCoordinate: CLLocationCoordinate2D?
    private var missionIDToPinImageView: [String: UIImageView] = [:]
    var missionIDToCoordinates: [String: CLLocationCoordinate2D] = [:]
    
    private func addViewAnnotations(coordinates: [CLLocationCoordinate2D], missionID: String) {
        for coordinate in coordinates {
            let options = ViewAnnotationOptions(
                geometry: Point(coordinate),
                width: 30,
                height: 30,
                allowOverlap: false,
                anchor: .bottom
            )
            
            if let iconImage = UIImage(named: "Pin") {
                let iconImageView = UIImageView(image: iconImage.withRenderingMode(.alwaysOriginal))
                iconImageView.contentMode = .center
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinImageTapped))
                iconImageView.isUserInteractionEnabled = true
                iconImageView.addGestureRecognizer(tapGestureRecognizer)
                
                // Associate mission ID with the pin image view
                missionIDToPinImageView[missionID] = iconImageView
                
                // Associate text "abc" with the pin image view
                missionIDToCoordinates[missionID] = coordinate
                
                try? mapView.viewAnnotations.add(iconImageView, options: options)
            }
        }
    }
    
    
    @objc private func pinImageTapped(sender: UITapGestureRecognizer) {
        // Retrieve the mission ID associated with the pin image view
        if let missionID = missionIDToPinImageView.first(where: { $0.value == sender.view })?.key {
            print("Text, Mission ID: \(missionID)")
            
            // Retrieve the text associated with the mission ID
            if let coordinate = missionIDToCoordinates[missionID] {
                print("Text: \(coordinate)")
                
                let newCamera = CameraOptions(center: coordinate, padding: UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0), zoom: 15)
                mapView.camera.ease(to: newCamera, duration: 1.0)
                
                
                // Present the DenseContentSheetViewController
                let viewController = DenseContentSheetViewController()
                viewController.preferredSheetSizing = .large
                self.present(viewController, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startingCoordinate = CLLocationCoordinate2D(latitude: 1.543451683610689, longitude: 102.64933494285206)
        let mapInitOptions = MapInitOptions(
            resourceOptions: ResourceOptions(accessToken: Constants.MAPBOX_TOKEN),
            cameraOptions: CameraOptions(center: startingCoordinate, zoom: 4),
            styleURI: StyleURI(rawValue: Constants.MAPBOX_STYLE)
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        try? mapView.mapboxMap.style.setProjection(StyleProjection(name: .globe))
        //        mapView.ornaments.logoView.isHidden = true
        //        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.scaleBarView.isHidden = true
        view.addSubview(mapView)
        
        APIService.fetchMissions { [weak self] missions in
            DispatchQueue.main.async {
                for mission in missions {
                    
                    var isFirstCoordinate = true
                    var ringCoords: [CLLocationCoordinate2D] = []
                    
                    for coordinate in mission.area.coordinate {
                        let latitude = Double(coordinate.latitude) ?? 0.0
                        let longitude = Double(coordinate.longitude) ?? 0.0
                        ringCoords.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        
                        // Add pin image on first coordinate of every mission
                        if isFirstCoordinate {
                            let firstCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            self?.addViewAnnotations(coordinates: [firstCoordinate], missionID: mission.missionId)
                            isFirstCoordinate = false
                        }
                    }
                    
                    // Draw mission area on map
                    let ring = Ring(coordinates: ringCoords)
                    let polygon = Polygon(outerRing: ring)
                    
                    var polygonAnnotation = PolygonAnnotation(polygon: polygon)
                    polygonAnnotation.fillColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 0.2))
                    polygonAnnotation.fillOutlineColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 1))
                    
                    let polygonAnnotationManager = self?.mapView.annotations.makePolygonAnnotationManager()
                    polygonAnnotationManager?.annotations.append(polygonAnnotation)
                    
                    // Fly Ease to first coordinate of first mission
                    if let firstMission = missions.first,
                       let firstCoordinate = firstMission.area.coordinate.first {
                        let latitude = Double(firstCoordinate.latitude) ?? 0.0
                        let longitude = Double(firstCoordinate.longitude) ?? 0.0
                        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        let newCamera = CameraOptions(center: centerCoordinate, zoom: 11, pitch: 50)
                        self?.mapView.camera.ease(to: newCamera, duration: 4.0)
                    }
                }
            }
        }
        
        // Create the floating action button
        let floatingActionButton = UIButton(type: .custom)
        floatingActionButton.setBackgroundImage(UIImage(named: "fly"), for: .normal)
        floatingActionButton.addTarget(self, action: #selector(floatingActionButtonTapped), for: .touchUpInside)
        
        // Add the floating action button to the view
        view.addSubview(floatingActionButton)
        
        // Position the floating action button
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingActionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingActionButton.widthAnchor.constraint(equalToConstant: 76),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 76)
        ])
        
        
    }
    
    func calculateCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard !coordinates.isEmpty else {
            return nil
        }
        
        var sumLat: CLLocationDegrees = 0
        var sumLon: CLLocationDegrees = 0
        
        for coordinate in coordinates {
            sumLat += coordinate.latitude
            sumLon += coordinate.longitude
        }
        
        let count = Double(coordinates.count)
        let centerLat = sumLat / count
        let centerLon = sumLon / count
        
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
    
    @objc private func floatingActionButtonTapped() {
        // Handle the tap event for the floating action button here
        print("Floating action button tapped!")
        
        // Instantiate the view controller from the storyboard
        //        let storyboard = UIStoryboard(name: "LiveView", bundle: nil)
        //        let viewController = storyboard.instantiateViewController(withIdentifier: "LiveViewStoryboard")
        //
        //       // Present the view controller
        //        self.present(viewController, animated: true)
        
        let viewController = DroneConnectorViewController()
        viewController.preferredSheetSizing = .large
        self.present(viewController, animated: true)
    }
    
    @objc private func missionIconTapped() {
        print("Mission icon tapped")
        let missionsViewController = UIHostingController(rootView: MissionsView())
        navigationController?.pushViewController(missionsViewController, animated: true)
    }
    
    @objc private func profileIconTapped() {
        print("Profile icon tapped")
        
        let profilePage = ProfilePage() // Create an instance of the SwiftUI view
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            let hostingController = UIHostingController(rootView: profilePage)
            viewController.present(hostingController, animated: true, completion: nil)
        }
    }
    
    func convertToCLLocationCoordinates(coordinates: [APIService.Coordinate]) -> [CLLocationCoordinate2D] {
        var convertedCoordinates: [CLLocationCoordinate2D] = []
        for coordinate in coordinates {
            if let latitude = Double(coordinate.latitude), let longitude = Double(coordinate.longitude) {
                let convertedCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                convertedCoordinates.append(convertedCoordinate)
            } else {
                // Handle conversion error, if necessary
                print("Error converting coordinate: \(coordinate)")
            }
        }
        return convertedCoordinates
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
