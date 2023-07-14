import SwiftUI
import MapboxMaps

struct MapBox: UIViewControllerRepresentable {
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
                width: 1,
                height: 1,
                allowOverlap: false,
                anchor: .center
            )
            
            // Create an image view for the icon
            if let url = URL(string: "https://w7.pngwing.com/pngs/361/830/png-transparent-map-pin-3d-icon.png"),
               let data = try? Data(contentsOf: url),
               let originalImage = UIImage(data: data),
               let resizedImage = originalImage.resized(to: CGSize(width: 30, height: 30)) {
                let iconImageView = UIImageView(image: resizedImage.withRenderingMode(.alwaysOriginal))
                iconImageView.contentMode = .center
                try? mapView.viewAnnotations.add(iconImageView, options: options)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 2.901207768844617, longitude: 101.65212468944911)
        
        let mapInitOptions = MapInitOptions(
            resourceOptions: ResourceOptions(accessToken: "pk.eyJ1IjoienZoaXI5OCIsImEiOiJjbDd5NmhmcHQwd3E2M25uM2xqNWpta2JrIn0.7WhQqynHwXzSI3O12u-nXA"),
            cameraOptions: CameraOptions(center: centerCoordinate, zoom: 12),
            styleURI: StyleURI(rawValue: "mapbox://styles/intuitivebadger/ckzz2zvzy010o14l8wocirazx")
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        let missionsButton = UIButton(type: .system)
        missionsButton.setTitle("Missions", for: .normal)
        missionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        missionsButton.translatesAutoresizingMaskIntoConstraints = false
        missionsButton.addTarget(self, action: #selector(openMissionsPage), for: .touchUpInside)
        view.addSubview(missionsButton)
        
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 3.058438, longitude: 101.688452),
            CLLocationCoordinate2D(latitude: 3.115537525738141, longitude: 101.76028890808064),
            CLLocationCoordinate2D(latitude: 3.058438, longitude: 101.688452)
        ]
        self.addViewAnnotations(coordinates: coordinates)
        
        NSLayoutConstraint.activate([
            missionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            missionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func openMissionsPage() {
        let missionsViewController = Missions()
        navigationController?.pushViewController(missionsViewController, animated: true)
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
