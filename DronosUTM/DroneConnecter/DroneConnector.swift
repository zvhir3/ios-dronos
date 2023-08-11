import UIKit
import DJISDK

final class DroneConnectorViewController: BottomSheetController {
    
    var segmentedControl: UISegmentedControl!
    var blurEffectView: UIVisualEffectView!
    
    var contentView1: UIView!
    var contentView2: UIView!
    var contentView3: UIView!
    var contentView4: UIView!
    
    var connectedImageView: UIImageView!
    var textLabel: UILabel!
    var connectionCheckTimer: Timer? // Timer variable to periodically check connection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start the connection check timer
        connectionCheckTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var version = DJISDKManager.sdkVersion()
        if version == "" {
            version = "N/A"
        }
    }
    
    @objc func checkConnection() {
        // This method will be called every second to check the connection
        ProductCommunicationService.shared.connectToProduct()
        if ProductCommunicationService.shared.connected {
            textLabel.text = "Connected"
            connectionCheckTimer?.invalidate()
            // Wait for 3 seconds and then display an alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let storyboard = UIStoryboard(name: "DefaultLayoutCustomization", bundle: nil)
                if let mainViewController = storyboard.instantiateInitialViewController() {
                    self.present(mainViewController, animated: true, completion: nil)
                }
            }
        } else {
            textLabel.text = "Please connect your mobile phone with registered drone"
        }
    }
    
    override func loadView() {
        super.loadView()
        
        // Create a blur effect view
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect) // Initialize the blurEffectView
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Create an image view
        let imageView = UIImageView(image: UIImage(named: "drone_connect")) // Replace "drone_connect" with your image name
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Center the image view on the screen
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200), // Set the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 200) // Set the height as needed
        ])
        
        // Create a label for the text
        textLabel = UILabel()
        textLabel.text = "Please connect your mobile phone with registered drone"
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.numberOfLines = 0 // Allow multiple lines of text
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "Barlow-Medium", size: 18)
        view.addSubview(textLabel)
        
        
        // Center the image view and text label on the screen
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30), // Adjust vertical position
            imageView.widthAnchor.constraint(equalToConstant: 200), // Set the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 200), // Set the height as needed
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20), // Add spacing between image and label
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Add leading padding
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Add trailing padding
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140) // Add padding at the bottom
        ])
        
        // Create an image view for the "Connected" image
        connectedImageView = UIImageView(image: UIImage(named: "connected")) // Replace "connected" with your image name
        connectedImageView.contentMode = .scaleAspectFit
        connectedImageView.translatesAutoresizingMaskIntoConstraints = false
        connectedImageView.isHidden = true // Hide the image initially
        view.addSubview(connectedImageView)
        
        // Create constraints for the connectedImageView
        NSLayoutConstraint.activate([
            connectedImageView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            connectedImageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10), // Add spacing between image and text
            connectedImageView.widthAnchor.constraint(equalToConstant: 20), // Set the width as needed
            connectedImageView.heightAnchor.constraint(equalToConstant: 20) // Set the height as needed
        ])
        
    }
    
    
    
    // Be sure to invalidate the timer when the view controller is dismissed
    deinit {
        connectionCheckTimer?.invalidate()
    }
}
