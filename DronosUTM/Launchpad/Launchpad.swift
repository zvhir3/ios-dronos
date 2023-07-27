import SwiftUI
import MapboxMaps

struct Launchpad: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

class ViewController: UIViewController {
    private var mapView: MapView!
    private var centerCoordinate: CLLocationCoordinate2D?
    private var missionIDToPinImageView: [String: UIImageView] = [:]
    
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
                
                try? mapView.viewAnnotations.add(iconImageView, options: options)
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
        
        // Create a list icon and set it as the left bar button item
        let listIcon = UIImage(systemName: "equal")
        let listButton = UIBarButtonItem(image: listIcon, style: .plain, target: self, action: #selector(missionIconTapped))
        navigationItem.leftBarButtonItem = listButton
        
        // Create a profile icon and set it as the right bar button item
        let profileIcon = UIImage(systemName: "person")
        let profileButton = UIBarButtonItem(image: profileIcon, style: .plain, target: self, action: #selector(profileIconTapped))
        navigationItem.rightBarButtonItem = profileButton
        
        APIService.fetchMissions { [weak self] missions in
            DispatchQueue.main.async {
                if let firstMission = missions.first {
                    self?.centerCoordinate = CLLocationCoordinate2D(
                        latitude: firstMission.area.coordinate.first?.latitudeDouble ?? 0,
                        longitude: firstMission.area.coordinate.first?.longitudeDouble ?? 0)
                    
                    for mission in missions {
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
    }
    
    @objc private func pinImageTapped(sender: UITapGestureRecognizer) {
           // Retrieve the mission ID associated with the pin image view
           if let missionID = missionIDToPinImageView.first(where: { $0.value == sender.view })?.key {
               print("Text, Mission ID: \(missionID)")

               // Create the SwiftUI "ViewMission" view and pass the mission ID to it
               let viewMissionView = ViewMissionView(missionID: missionID)

               // Push the "ViewMission" view using SwiftUI's navigation
               if let hostingController = self.parent {
                   hostingController.navigationController?.pushViewController(UIHostingController(rootView: viewMissionView), animated: true)
               }
           }
       }
    
    @objc private func missionIconTapped() {
        print("Mission icon tapped")
        let missionsViewController = Missions()
        navigationController?.pushViewController(missionsViewController, animated: true)
    }
    
    @objc private func profileIconTapped() {
        print("Profile icon tapped")
        let profilePageHostingController = UIHostingController(rootView: ProfilePage())
        navigationController?.present(profilePageHostingController, animated: true, completion: nil)
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
