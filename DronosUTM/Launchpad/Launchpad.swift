import SwiftUI
import MapboxMaps

struct Launchpad: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        let viewController = ViewController()
        let missionsViewController = Missions()
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

//import UIKit
//
//final class LaunchpadViewController: UIViewController {
//
//    private let stackView = UIStackView()
//
//    override func loadView() {
//        view = UIView()
//
//        let sparseContentFitButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = SparseContentSheetViewController()
//            viewController.preferredSheetSizing = .fit
//            self.present(viewController, animated: true)
//        }))
//        sparseContentFitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        sparseContentFitButton.setTitle("Sparse content - fit", for: .normal)
//
//        let sparseContentSmallButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = SparseContentSheetViewController()
//            viewController.preferredSheetSizing = .small
//            self.present(viewController, animated: true)
//        }))
//        sparseContentSmallButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        sparseContentSmallButton.setTitle("Sparse content - small", for: .normal)
//
//        let sparseContentMediumButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = SparseContentSheetViewController()
//            viewController.preferredSheetSizing = .medium
//            self.present(viewController, animated: true)
//        }))
//        sparseContentMediumButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        sparseContentMediumButton.setTitle("Sparse content - medium", for: .normal)
//
//        let sparseContentLargeButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = SparseContentSheetViewController()
//            viewController.preferredSheetSizing = .large
//            self.present(viewController, animated: true)
//        }))
//        sparseContentLargeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        sparseContentLargeButton.setTitle("Sparse content - large", for: .normal)
//
//        let sparseContentFillButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = SparseContentSheetViewController()
//            viewController.preferredSheetSizing = .fill
//            self.present(viewController, animated: true)
//        }))
//        sparseContentFillButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        sparseContentFillButton.setTitle("Sparse content - fill", for: .normal)
//
//        let sparseContentStackView = UIStackView(arrangedSubviews: [
//            sparseContentFitButton,
//            sparseContentSmallButton,
//            sparseContentMediumButton,
//            sparseContentLargeButton,
//            sparseContentFillButton
//        ])
//        sparseContentStackView.axis = .vertical
//        sparseContentStackView.spacing = 8
//
//        let denseContentFitButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = DenseContentSheetViewController()
//            viewController.preferredSheetSizing = .fit
//            self.present(viewController, animated: true)
//        }))
//        denseContentFitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        denseContentFitButton.setTitle("Dense content - fit", for: .normal)
//
//        let denseContentSmallButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = DenseContentSheetViewController()
//            viewController.preferredSheetSizing = .small
//            self.present(viewController, animated: true)
//        }))
//        denseContentSmallButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        denseContentSmallButton.setTitle("Dense content - small", for: .normal)
//
//        let denseContentMediumButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = DenseContentSheetViewController()
//            viewController.preferredSheetSizing = .medium
//            viewController.panToDismissEnabled = false
//            self.present(viewController, animated: true)
//        }))
//        denseContentMediumButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        denseContentMediumButton.setTitle("Dense content - medium", for: .normal)
//
//        let denseContentLargeButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = DenseContentSheetViewController()
//            viewController.preferredSheetSizing = .large
//            self.present(viewController, animated: true)
//        }))
//        denseContentLargeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        denseContentLargeButton.setTitle("Dense content - large", for: .normal)
//
//        let denseContentFillButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = DenseContentSheetViewController()
//            viewController.preferredSheetSizing = .fill
//            self.present(viewController, animated: true)
//        }))
//        denseContentFillButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        denseContentFillButton.setTitle("Dense content - fill", for: .normal)
//
//        let denseContentStackView = UIStackView(arrangedSubviews: [
//            denseContentFitButton,
//            denseContentSmallButton,
//            denseContentMediumButton,
//            denseContentLargeButton,
//            denseContentFillButton
//        ])
//        denseContentStackView.axis = .vertical
//        denseContentStackView.spacing = 8
//
//        let expandingContentFitButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = ExpandingContentSheetViewController()
//            viewController.preferredSheetSizing = .fit
//            viewController.panToDismissEnabled = false
//            self.present(viewController, animated: true)
//        }))
//        expandingContentFitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        expandingContentFitButton.setTitle("Expanding content - fit", for: .normal)
//
//        let tableContentMediumButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = TableContentSheetViewController()
//            viewController.preferredSheetSizing = .medium
//            self.present(viewController, animated: true)
//        }))
//        tableContentMediumButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        tableContentMediumButton.setTitle("Table content - medium", for: .normal)
//
//        let lifecycleDependentContentLargeButton = UIButton(type: .system, primaryAction: .init(handler: { _ in
//            let viewController = LifecycleDependentContentSheetViewController()
//            viewController.preferredSheetSizing = .large
//            self.present(viewController, animated: true)
//        }))
//        lifecycleDependentContentLargeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
//        lifecycleDependentContentLargeButton.setTitle("Lifecycle dependent content - large", for: .normal)
//
//        let miscContentStackView = UIStackView(arrangedSubviews: [
//            expandingContentFitButton,
//            tableContentMediumButton,
//            lifecycleDependentContentLargeButton
//        ])
//        miscContentStackView.axis = .vertical
//        miscContentStackView.spacing = 8
//
//        let axis: NSLayoutConstraint.Axis = traitCollection.verticalSizeClass == .compact
//            ? .horizontal
//            : .vertical
//
//        stackView.addArrangedSubview(sparseContentStackView)
//        stackView.addArrangedSubview(denseContentStackView)
//        stackView.addArrangedSubview(miscContentStackView)
//        stackView.axis = axis
//        stackView.spacing = 16
//
//        view.addSubview(stackView)
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//
//        view.backgroundColor = .systemBackground
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        let axis: NSLayoutConstraint.Axis = traitCollection.verticalSizeClass == .compact
//            ? .horizontal
//            : .vertical
//
//        stackView.axis = axis
//    }
//}
