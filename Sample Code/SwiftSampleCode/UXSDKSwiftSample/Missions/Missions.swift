import UIKit

class Missions: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        // Set the background color
        view.backgroundColor = .white
        
        // Create and configure the title label
        let titleLabel = UILabel()
        titleLabel.text = "Today's Missions"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the stack view for the cards
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create three cards
        for _ in 1...3 {
            let cardView = createCardView()
            stackView.addArrangedSubview(cardView)
            
            // Add tap gesture recognizer to the card
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
            cardView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        // Add the views to the main view
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func createCardView() -> UIView {
        // Create the card view
        let cardView = UIView()
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true // Enable user interaction for tap gesture recognizer
        
        // Create and configure the title label
        let titleLabel = UILabel()
        titleLabel.text = "Mission Title"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the coordinates label
        let coordinatesLabel = UILabel()
        coordinatesLabel.text = "Coordinates: (x, y, z)"
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the fly button
        let flyButton = UIButton(type: .system)
        flyButton.setTitle("Fly", for: .normal)
        flyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        flyButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the subviews to the card view
        cardView.addSubview(titleLabel)
        cardView.addSubview(coordinatesLabel)
        cardView.addSubview(flyButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            coordinatesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            coordinatesLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            flyButton.topAnchor.constraint(equalTo: coordinatesLabel.bottomAnchor, constant: 16),
            flyButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            flyButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        // Open the Main Storyboard or a specific view controller
        // Add your code to navigate to the desired destination
        // For example, you can use the following code to open the Main Storyboard
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateInitialViewController()
        
        guard let navigationController = self.navigationController else {
            fatalError("Missions view controller is not embedded in a navigation controller")
        }
        
        navigationController.pushViewController(mainViewController!, animated: true)
    }
}
