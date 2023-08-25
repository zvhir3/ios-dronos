import SwiftUI
import MapboxMaps
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
    private var centerCoordinate: CLLocationCoordinate2D?
    var missionDetails: [String: APIService.Mission] = [:]
    var missionIDToCoordinates: [String: CLLocationCoordinate2D] = [:]
    var connectionCheckTimer: Timer?
    @State private var profile: Profile? = nil
    @State private var workspaceId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                connectionCheckTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                    self?.publishTelemetry()
                }
        
                // Run the timer on the current run loop
                RunLoop.current.add(connectionCheckTimer!, forMode: .common)
        
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
        
        Task {
            await loadData()
        }
        
    }
    
    func fetchMissionsAsync(workspaceId: String) async -> [APIService.Mission] {
        return await withCheckedContinuation { continuation in
            APIService.fetchMissions(workspaceId: workspaceId) { missions in
                continuation.resume(returning: missions)
            }
        }
    }
    
    private func addViewAnnotations(coordinates: CLLocationCoordinate2D, missionID: String) {
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
            print("here -----", missionID)
            
            // Create a tap gesture recognizer
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinImageTapped(_:)))
            
            // Use a closure to associate the mission ID with the gesture recognizer
            tapGestureRecognizer.accessibilityValue = missionID
            
            // Pass the coordinates as the gesture recognizer's accessibilityHint
            tapGestureRecognizer.accessibilityHint = "\(coordinates.latitude), \(coordinates.longitude)"
            
            iconImageView.isUserInteractionEnabled = true
            iconImageView.addGestureRecognizer(tapGestureRecognizer)
            
            try? mapView.viewAnnotations.add(iconImageView, options: options)
        }
    }
    
    @objc private func pinImageTapped(_ sender: UITapGestureRecognizer) {
        if let missionID = sender.accessibilityValue,
           let coordinatesString = sender.accessibilityHint {
            print("Icon image tapped for mission ID:", missionID)
            
            // Extract and print the coordinates
            print("Coordinates:", coordinatesString)
            
            // Parse the coordinates string to get latitude and longitude
            let coordinateComponents = coordinatesString.split(separator: ",")
            if coordinateComponents.count == 2,
               let latitude = Double(coordinateComponents[0].trimmingCharacters(in: .whitespaces)),
               let longitude = Double(coordinateComponents[1].trimmingCharacters(in: .whitespaces)) {
                
                // Update the camera to focus on the tapped coordinate
                let newCamera = CameraOptions(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), padding: UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0), zoom: 10)
                mapView.camera.ease(to: newCamera, duration: 5.0)
            }
        }
    }
    
    func loadData() async {
        if let fetchedProfile = await getProfileAsync() {
            if !fetchedProfile.workspaceId.isEmpty {
                let missions = await fetchMissionsAsync(workspaceId: fetchedProfile.workspaceId)
                print("tengok workspace", missions)
                DispatchQueue.main.async { [weak self] in
                    for (missionIndex, mission) in missions.enumerated() {
                        print("Mission loop index: ", missionIndex, " mission name: ", mission.name, missionIndex, " mission id: ", mission.missionId)
                        // Declare a clean and empty polygon coordinates array
                        var polygonCoordinates: [CLLocationCoordinate2D] = []
                        
                        // Assign all coordinates to coordinates array
                        for (coordinateIndex, coordinate) in mission.area.coordinate.enumerated() {
                            if (-90.0...90.0).contains(coordinate.latitudeDouble) && (-180.0...180.0).contains(coordinate.longitudeDouble) {
                                
                                // Assign this coordinate to coordinate array
                                polygonCoordinates.append(CLLocationCoordinate2D(latitude: coordinate.latitudeDouble, longitude: coordinate.longitudeDouble))
                                print("Coordinate loop index: ", coordinateIndex," latitude: ", coordinate.latitudeDouble, " longitude: ", coordinate.longitudeDouble)
                                
                                // Draw pin on first coordinate
                                if (coordinateIndex == 0) {
                                    let firstCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitudeDouble, longitude: coordinate.longitudeDouble)
                                    self?.addViewAnnotations(coordinates: firstCoordinate, missionID: mission.id)
                                    
                                    // Fly to first mission first coordinate
                                    if(missionIndex == 1){
                                        let newCamera = CameraOptions(center: CLLocationCoordinate2D(latitude: coordinate.latitudeDouble, longitude: coordinate.longitudeDouble), padding: UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0), zoom: 10)
                                        self?.mapView.camera.ease(to: newCamera, duration: 5.0)
                                    }
                                }
                            } else {
                                // Handle invalid coordinate
                                print("Invalid coordinate: latitude \(coordinate.latitudeDouble), longitude \(coordinate.longitudeDouble)")
                            }
                        }
                        // Append first coordinate of the mission to the last polygon array, so it is closed polygon
                        if let firstCoordinate = polygonCoordinates.first {
                            polygonCoordinates.append(firstCoordinate)
                        }
                        
                        // Create polygon area
                        let polygonRing = Ring(coordinates: polygonCoordinates)
                        let polygonArea = Polygon(outerRing: polygonRing)
                        
                        if let polygonAnnotationManager = self?.mapView.annotations.makePolygonAnnotationManager() {
                            var polygonAnnotation1 = PolygonAnnotation(polygon: polygonArea)
                            polygonAnnotation1.fillColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 0.2))
                            polygonAnnotation1.fillOutlineColor = StyleColor(UIColor(red: 0, green: 0.94, blue: 1, alpha: 1))
                            polygonAnnotationManager.annotations = [polygonAnnotation1]
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    func publishTelemetry(){
        
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
        
        ProductCommunicationService.shared.connectToProduct()
        if ProductCommunicationService.shared.connected {
            
            floatingActionButton.setBackgroundImage(UIImage(named: "connected_button"), for: .normal)
            
            print("Product Connected")
            print("Trying to publish telemetry to MQTT")
            let clientID = "utm_mobile"
            let host = "emqx-mqtt.dronos.ai"
            let username = "admin"
            let password = "tU$Cy*@&pcfZV7467Ebu"
            
            let mqtt = CocoaMQTT(clientID: clientID, host: host, port: 1883)
            mqtt.username = username
            mqtt.password = password
            mqtt.keepAlive = 60
            
            mqtt.didConnectAck = { mqtt, ack in
                if ack == .accept {
                    print("Connected to MQTT broker")
                    let topic = "thing/product/1581F5FHB22A70020AD8/osd"
                    mqtt.publish(topic, withString: "Start publish telemetry")
                    let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
                    
                    DJISDKManager.keyManager()?.startListeningForChanges(on: locationKey!, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                        if newValue != nil {
                            // DJIFlightControllerParamAircraftLocation is associated with a DJISDKLocation object
                            let aircraftCoordinates = newValue!.value! as! CLLocation
                            
                            //print("Altitude: \(aircraftCoordinates.altitude) -  Speed: \(aircraftCoordinates.timestamp)")
                            print("Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)")
                            mqtt.publish(topic, withString: "Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)")
                            
                        }
                        else{
                            print("No data")
                        }
                    })
                    
                    
                }
            }
            
            mqtt.connect()
        } else {
            print("No drone connected")
        }
        
    }
    
    func getProfile(completion: @escaping (Profile?) -> Void) {
        guard let savedToken = UserDefaults.standard.object(forKey: "token") as? String else {
            completion(nil)
            return
        }
        APIService.getProfile(token: savedToken) { apiProfile in
            guard let apiProfile = apiProfile else {
                completion(nil)
                return
            }
            
            let convertedProfile = Profile(
                id: apiProfile.id,
                firstName: apiProfile.firstName,
                lastName: apiProfile.lastName,
                email: apiProfile.email,
                workspaceId: apiProfile.workspaceId
            )
            completion(convertedProfile)
        }
    }
    
    func getProfileAsync() async -> Profile? {
        return await withCheckedContinuation { continuation in
            getProfile { profile in
                continuation.resume(returning: profile)
            }
        }
    }
    
    @objc private func floatingActionButtonTapped() {
        // Handle the tap event for the floating action button here
        print("Floating action button tapped!")
        // Present the DenseContentSheetViewController
        let viewController = DroneConnectorViewController()
        viewController.preferredSheetSizing = .large
        self.present(viewController, animated: true)
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

