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
    var missionDetails: [String: APIService.Mission] = [:]
    
    private func addViewAnnotations(coordinates: [CLLocationCoordinate2D], missionID: String) {
        for coordinate in coordinates {
            let options = ViewAnnotationOptions(
                geometry: Point(coordinate),
                width: 30,
                height: 30,
                allowOverlap: false,
                anchor: .center
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
            
            let missionDetail = missionDetails[missionID]
            
            // Retrieve the text associated with the mission ID
            if let coordinate = missionIDToCoordinates[missionID] {
                print("Text: \(coordinate)")
                
                let newCamera = CameraOptions(center: coordinate, padding: UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0), zoom: 15)
                mapView.camera.ease(to: newCamera, duration: 1.0)
                
                
                // Present the DenseContentSheetViewController
                let viewController = DenseContentSheetViewController()
                viewController.missionDetail = missionDetail

                self.present(viewController, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapInitOptions = MapInitOptions(
            resourceOptions: ResourceOptions(accessToken: Constants.MAPBOX_TOKEN),
            cameraOptions: CameraOptions(center: centerCoordinate, zoom: 2),
            styleURI: StyleURI(rawValue: Constants.MAPBOX_STYLE)
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        try? mapView.mapboxMap.style.setProjection(StyleProjection(name: .globe))
        mapView.ornaments.logoView.isHidden = true
        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.scaleBarView.isHidden = true
        view.addSubview(mapView)
        
        APIService.fetchMissions { [weak self] missions in
            DispatchQueue.main.async {
                if let firstMission = missions.first {
                    self?.centerCoordinate = CLLocationCoordinate2D(
                        latitude: firstMission.area.coordinate.first?.latitudeDouble ?? 0,
                        longitude: firstMission.area.coordinate.first?.longitudeDouble ?? 0)
                    
                    for mission in missions {
                        self?.missionDetails[mission.missionId] = mission
                        if let coordinates = self?.convertToCLLocationCoordinates(coordinates: mission.area.coordinate) {
                            // Pass the mission ID along with coordinates
                            self?.addViewAnnotations(coordinates: coordinates, missionID: mission.missionId)
                            
                        } else {
                            print("Coordinates are nil or invalid.")
                        }
                    }
                    
                    // After fetching missions, set the new camera position
                    if let centerCoordinate = self?.centerCoordinate {
                        let newCamera = CameraOptions(center: centerCoordinate, zoom: 5, pitch: 45)
                        self?.mapView.camera.ease(to: newCamera, duration: 5.0)
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
        
        // Define coordinates for the first polygon
        let ringCoords1 = [
            CLLocationCoordinate2DMake( 2.791022, 101.617583),
            CLLocationCoordinate2DMake(2.950794, 101.895892),
            CLLocationCoordinate2DMake( 2.8988322803233366, 101.64227583014568),
        ]
        
        // Calculate the center coordinate for the first polygon
        if let centerCoordinate1 = calculateCenterCoordinate(for: ringCoords1) {
            print("Center Coordinate for Polygon 1: \(centerCoordinate1)")
        } else {
            print("Invalid coordinates for Polygon 1.")
        }
        
        // Create the Ring and Polygon for the first polygon
        let ring1 = Ring(coordinates: ringCoords1)
        let polygon1 = Polygon(outerRing: ring1)
        
        // Create a new polygon annotation for the first polygon
        var polygonAnnotation1 = PolygonAnnotation(polygon: polygon1)
        polygonAnnotation1.fillColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 0.2))
        polygonAnnotation1.fillOutlineColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 1))
        
        // Define coordinates for the second polygon
        let coordinates = [
            [
                [
                    101.45481976,
                    3.1194105
                ],
                [
                    101.45481194,
                    3.1266476
                ],
                [
                    101.45474977,
                    3.13129999
                ],
                [
                    101.45472662,
                    3.13404009
                ],
                [
                    101.45097263,
                    3.13383449
                ],
                [
                    101.45082316,
                    3.13631802
                ],
                [
                    101.45167009,
                    3.13766639
                ],
                [
                    101.45280014,
                    3.13778881
                ],
                [
                    101.45394309,
                    3.13756001
                ],
                [
                    101.4548547,
                    3.13991572
                ],
                [
                    101.45695708,
                    3.14489794
                ],
                [
                    101.45796465,
                    3.14714812
                ],
                [
                    101.45815602,
                    3.14736691
                ],
                [
                    101.4596411,
                    3.14920435
                ],
                [
                    101.46135446,
                    3.15167497
                ],
                [
                    101.46266058,
                    3.1533284
                ],
                [
                    101.46424742,
                    3.15454856
                ],
                [
                    101.46532209,
                    3.1553614
                ],
                [
                    101.46743347,
                    3.15705385
                ],
                [
                    101.46867626,
                    3.15789532
                ],
                [
                    101.46910542,
                    3.15806441
                ],
                [
                    101.47052866,
                    3.15815507
                ],
                [
                    101.47116606,
                    3.15852979
                ],
                [
                    101.47309867,
                    3.16047212
                ],
                [
                    101.47169907,
                    3.16132684
                ],
                [
                    101.47095346,
                    3.16190234
                ],
                [
                    101.4696393,
                    3.16276223
                ],
                [
                    101.46826617,
                    3.16379552
                ],
                [
                    101.46720632,
                    3.16450515
                ],
                [
                    101.46632335,
                    3.1651142
                ],
                [
                    101.46420596,
                    3.16660705
                ],
                [
                    101.4631755,
                    3.16735375
                ],
                [
                    101.46254777,
                    3.16781179
                ],
                [
                    101.46123224,
                    3.16872998
                ],
                [
                    101.45757395,
                    3.17142833
                ],
                [
                    101.45500284,
                    3.17314801
                ],
                [
                    101.45257612,
                    3.17484169
                ],
                [
                    101.4439094,
                    3.18083729
                ],
                [
                    101.43876369,
                    3.18433617
                ],
                [
                    101.4331006,
                    3.1882981
                ],
                [
                    101.42771247,
                    3.19201251
                ]
            ]
        ]
        
        // Convert the provided coordinates to CLLocationCoordinate2D
        let ringCoords2: [CLLocationCoordinate2D] = coordinates[0].map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
        
        // Calculate the center coordinate for the second polygon
        if let centerCoordinate2 = calculateCenterCoordinate(for: ringCoords2) {
            print("Center Coordinate for Polygon 2: \(centerCoordinate2)")
        } else {
            print("Invalid coordinates for Polygon 2.")
        }
        
        // Create the Ring and Polygon for the second polygon
        let ring2 = Ring(coordinates: ringCoords2)
        let polygon2 = Polygon(outerRing: ring2)
        
        // Create a new polygon annotation for the second polygon
        var polygonAnnotation2 = PolygonAnnotation(polygon: polygon2)
        polygonAnnotation2.fillColor = StyleColor(UIColor(hue: 0.0472, saturation: 1, brightness: 0.94, alpha: 0.2))
        polygonAnnotation2.fillOutlineColor = StyleColor(UIColor(hue: 0.0472, saturation: 1, brightness: 0.94, alpha: 1.0))
        
        // Create the `PolygonAnnotationManager` which will be responsible for handling these annotations
        let polygonAnnotationManager = mapView.annotations.makePolygonAnnotationManager()
        
        // Add the polygons to the map as annotations.
        polygonAnnotationManager.annotations = [polygonAnnotation1, polygonAnnotation2]
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
        // Present the DenseContentSheetViewController
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
