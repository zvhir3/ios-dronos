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
    
    private func addViewAnnotations(coordinates: [CLLocationCoordinate2D]) {
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
                try? mapView.viewAnnotations.add(iconImageView, options: options)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 2.901207768844617, longitude: 101.65212468944911)
        
        let mapInitOptions = MapInitOptions(
            resourceOptions: ResourceOptions(accessToken: Constants.MAPBOX_TOKEN),
            cameraOptions: CameraOptions(center: centerCoordinate, zoom: 2),
            styleURI: StyleURI(rawValue: Constants.MAPBOX_STYLE)
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        try? mapView.mapboxMap.style.setProjection(StyleProjection(name: .globe))
        view.addSubview(mapView)
        
        let missionsButton = UIButton(type: .system)
        missionsButton.setTitle("Missions", for: .normal)
        missionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        missionsButton.translatesAutoresizingMaskIntoConstraints = false
        missionsButton.addTarget(self, action: #selector(openMissionsPage), for: .touchUpInside)
        view.addSubview(missionsButton)
        
       
        APIService.fetchMissions { [weak self] missions in
            DispatchQueue.main.async {
                for mission in missions {
                    print("###########")
                    if let coordinates = self?.convertToCLLocationCoordinates(coordinates: mission.area.coordinate) {
                        print(coordinates)
                        self?.addViewAnnotations(coordinates: coordinates)
                    } else {
                        print("Coordinates are nil or invalid.")
                    }
                }
            }
        }
        
        NSLayoutConstraint.activate([
            missionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func openMissionsPage() {
        let missionsViewController = Missions()
        navigationController?.pushViewController(missionsViewController, animated: true)
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
