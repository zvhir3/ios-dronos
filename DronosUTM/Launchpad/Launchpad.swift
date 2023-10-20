import SwiftUI
import MapboxMaps
import SQLite3
import CocoaMQTT

struct LaunchpadControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LaunchpadController {
        return LaunchpadController()
    }
    
    func updateUIViewController(_ uiViewController: LaunchpadController, context: Context) {
        // You can perform updates if needed
    }
}

class LaunchpadController: UIViewController {
    
    private var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startingCoordinate = CLLocationCoordinate2D(latitude: 0.6664763562990147, longitude: 98.54248632886225)
        let mapInitOptions = MapInitOptions(
            resourceOptions: ResourceOptions(accessToken: Constants.MAPBOX_TOKEN),
            cameraOptions: CameraOptions(center: startingCoordinate, zoom: 1),
            styleURI: StyleURI(rawValue: Constants.MAPBOX_STYLE)
        )
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        try? mapView.mapboxMap.style.setProjection(StyleProjection(name: .globe))
        mapView.ornaments.logoView.isHidden = true
        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.scaleBarView.isHidden = true
        view.addSubview(mapView)
        fetchMissions()
    }
    
    func fetchMissions() {
        ApiManager.shared.fetchMissions { result in
            switch result {
            case .success(let missionData):
                print("Missions fetched successfully")
                
                if let records = missionData.records {
                    var polygonCoordinates: [CLLocationCoordinate2D] = []
                    
                    for (missionIndex, record) in records.enumerated() {
                        print("\n\n-------------------------------------")
                        if let missionId = record.missionId {
                            print("Index: \(missionIndex), Mission ID: \(missionId)")
                            if let area = record.area {
                                // Accessing the coordinates
                                if let coordinates = area.coordinate {
                                    for (coordinateIndex, coordinate) in coordinates.enumerated() {
                                        // THIS LATITUDE AND LONGITUDE IS SWAPPED, NEED TO REFER TO BACKEND API TO CORRECT IT
                                        if let latitudeStr = coordinate.longitude, let longitudeStr = coordinate.latitude,
                                           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                                            if (-90.0...90.0).contains(latitude) && (-180.0...180.0).contains(longitude) {
                                                print("Coordinate index: \(coordinateIndex) - Latitude: \(latitude), Longitude: \(longitude)")
                                                polygonCoordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                                // Draw pin on first coordinate
                                                if (coordinateIndex == 0) {
                                                    let firstCoordinate = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
                                                    self.addViewAnnotations(coordinates: firstCoordinate, missionID: missionId, schedules: record.schedules ?? [])
                                                }
                                                if(missionIndex == 1){
                                                    let newCamera = CameraOptions(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), padding: UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0), zoom: 10)
                                                    self.mapView.camera.ease(to: newCamera, duration: 5.0)
                                                }
                                            } else {
                                                print("Invalid coordinates")
                                            }
                                        } else {
                                            print("Invalid coordinate values")
                                        }
                                    }
                                }
                                if let firstCoordinate = polygonCoordinates.first {
                                    polygonCoordinates.append(firstCoordinate)
                                }
                            }
                        }
                        
                    }
                    
                    
                    // Create polygon area
                    let polygonRing = Ring(coordinates: polygonCoordinates)
                    let polygonArea = Polygon(outerRing: polygonRing)
                    
                    let polygonAnnotationManager = self.mapView.annotations.makePolygonAnnotationManager()
                    var polygonAnnotation1 = PolygonAnnotation(polygon: polygonArea)
                    polygonAnnotation1.fillColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 0.2))
                    polygonAnnotation1.fillOutlineColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 1))
                    polygonAnnotationManager.annotations = [polygonAnnotation1]
                    
                }
                
            case .failure(let error):
                print("Failed to fetch missions: \(error)")
            }
        }
    }
    
    private func addViewAnnotations(coordinates: CLLocationCoordinate2D, missionID: String, schedules: [MissionModel.Schedule]) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinates),
            width: 30,
            height: 30,
            allowOverlap: false,
            anchor: .bottom
        )
        
        if let iconImage = UIImage(named: "Pin") {
            let iconImageView = UIImageView(image: iconImage.withRenderingMode(.alwaysOriginal))
            iconImageView.contentMode = .bottom
            
            // Create a tap gesture recognizer
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinImageTapped(_:)))
            
            // Use a closure to associate the mission ID with the gesture recognizer
            tapGestureRecognizer.accessibilityValue = missionID
            
            // Pass the coordinates as the gesture recognizer's accessibilityHint
            tapGestureRecognizer.accessibilityHint = "\(coordinates.latitude), \(coordinates.longitude)"
            
            // Pass the scedules as the gesture recognizer's accessibilityHint
            let schedulesData = try? JSONEncoder().encode(schedules)
            let schedulesBase64String = schedulesData?.base64EncodedString()
            tapGestureRecognizer.accessibilityLabel = schedulesBase64String
            
            iconImageView.isUserInteractionEnabled = true
            iconImageView.addGestureRecognizer(tapGestureRecognizer)
            
            try? mapView.viewAnnotations.add(iconImageView, options: options)
        }
    }
    
    @objc private func pinImageTapped(_ sender: UITapGestureRecognizer) {
        if let missionID = sender.accessibilityValue,
           let coordinatesString = sender.accessibilityHint,
           let schedulesBase64String = sender.accessibilityLabel {
            print("Icon image tapped for mission ID:", missionID)
            print("Coordinates:", coordinatesString)
            
            let coordinateComponents = coordinatesString.split(separator: ",")
            if coordinateComponents.count == 2,
               let latitude = Double(coordinateComponents[0].trimmingCharacters(in: .whitespaces)),
               let longitude = Double(coordinateComponents[1].trimmingCharacters(in: .whitespaces)) {
                
                let newCamera = CameraOptions(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), padding: UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0), zoom: 10)
                mapView.camera.ease(to: newCamera, duration: 5.0)
            }
            
            if let schedulesData = Data(base64Encoded: schedulesBase64String),
               let schedules = try? JSONDecoder().decode([MissionModel.Schedule].self, from: schedulesData) {
                let swiftUIView =  MissionSheet(missionId: missionID, schedules: schedules)
                let hostingController = UIHostingController(rootView: swiftUIView)
                present(hostingController, animated: true, completion: nil)
            }
        }
    }

}

