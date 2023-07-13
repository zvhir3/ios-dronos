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
    
    private func createSampleView(withText text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 180,
            height: 30,
            allowOverlap: false,
            anchor: .center
        )
        let sampleView = createSampleView(withText: "Today's Missions")
        try? mapView.viewAnnotations.add(sampleView, options: options)
        
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
        self.addViewAnnotation(at: centerCoordinate)

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
