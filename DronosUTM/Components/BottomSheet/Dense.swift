import UIKit

final class DenseContentSheetViewController: BottomSheetController {
    
    var segmentedControl: UISegmentedControl!
    var blurEffectView: UIVisualEffectView!
    
    var contentView1: UIView!
    var contentView2: UIView!
    var contentView3: UIView!
    var contentView4: UIView!
    
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
        
        // Add UILabel with the text "Gas Leak Detection"
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel.font = UIFont(name: "Barlow-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        titleLabel.attributedText = NSMutableAttributedString(string: "Gas Leak Detection", attributes: [NSAttributedString.Key.kern: 0.72, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        blurEffectView.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16).isActive = true // Align to the left edge with a constant margin of 16.
        titleLabel.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor, constant: 16).isActive = true // Align to the top edge with a constant margin of 16.
        
        // Add the button to the top-right corner with padding
        let button = UIButton(type: .system)
        button.setTitle("Not started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 0.2)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        blurEffectView.contentView.addSubview(button)
        button.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -16).isActive = true // Align to the right edge with a constant margin of -16.
        button.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true // Align with the top edge of the titleLabel.
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true // Set a fixed width for the button (change this value as needed).
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true // Set a fixed height for the button.
        
        // Add UILabel with the text "MSN 9304830"
        let label = UILabel()
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        label.font = UIFont(name: "Barlow-Regular", size: 12)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        label.attributedText = NSMutableAttributedString(string: "MSN 9304830", attributes: [NSAttributedString.Key.kern: 4, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        blurEffectView.contentView.addSubview(label) // Add label to the blurEffectView's contentView
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16).isActive = true // Align to the left edge with a constant margin of 16.
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true // Place below the titleLabel with a constant margin of 2.
        
        let imageView = UIImageView(image: UIImage(named: "mountain"))
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8 // Set the corner radius for rounded corners
        imageView.layer.masksToBounds = true
        
        blurEffectView.contentView.addSubview(imageView) // Add imageView to the blurEffectView's contentView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16).isActive = true // Align to the left edge with a constant margin of 16.
        imageView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -16).isActive = true // Align to the right edge with a constant margin of -16.
        imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12).isActive = true // Add padding of 12 points to the top of the imageView.
        if let image = imageView.image {
            let aspectRatioMultiplier = image.size.height / image.size.width
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatioMultiplier, constant: 0).isActive = true
        }
        
        // Create the segmented control and add it to the contentView
        segmentedControl = UISegmentedControl(items: ["Tab 1", "Tab 2", "Tab 3", "Tab 4"])
        segmentedControl.selectedSegmentIndex = 0 // Set the initially selected segment
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        blurEffectView.contentView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -16).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        
        
        // Set the images for the selected states of each segment
        let tab1ActiveImage = UIImage(named: "segment_mission")?.withRenderingMode(.alwaysOriginal)
        segmentedControl.setImage(tab1ActiveImage, forSegmentAt: 0)
        
        let tab2ActiveImage = UIImage(named: "segment_drone")?.withRenderingMode(.alwaysOriginal)
        segmentedControl.setImage(tab2ActiveImage, forSegmentAt: 1)
        
        let tab3ActiveImage = UIImage(named: "segment_pilot")?.withRenderingMode(.alwaysOriginal)
        segmentedControl.setImage(tab3ActiveImage, forSegmentAt: 2)
        
        let tab4ActiveImage = UIImage(named: "segment_weather")?.withRenderingMode(.alwaysOriginal)
        segmentedControl.setImage(tab4ActiveImage, forSegmentAt: 3)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.22, green: 0.25, blue: 0.3, alpha: 1)], for: .selected)
        segmentedControl.selectedSegmentTintColor = UIColor(red: 0, green: 0.94, blue: 1, alpha: 1)
        segmentedControl.backgroundColor = UIColor(red: 0.31, green: 0.36, blue: 0.43, alpha: 1)
        
        // Create and add the content views for each tab
        contentView1 = createContentViewMission()
        contentView2 = createContentView(with: "Content for Tab 2")
        contentView3 = createContentView(with: "Content for Tab 3")
        contentView4 = createContentView(with: "Content for Tab 4")
        
        // Show the initial content view based on the initially selected segment
        showContentView(at: segmentedControl.selectedSegmentIndex)
    }
    
    @objc func segmentedControlValueChanged() {
        // Show the corresponding content view when the segmented control value changes
        showContentView(at: segmentedControl.selectedSegmentIndex)
    }
    
    
    func createContentViewMission() -> UIView {
        let contentView = UIView()
        contentView.isHidden = true // Initially hide the content view
        
        // Add the title label
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.26
        titleLabel.attributedText = NSMutableAttributedString(string: "MISSION SCHEDULE", attributes: [NSAttributedString.Key.kern: 4, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        // Add the separator line
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 0.376, green: 0.431, blue: 0.475, alpha: 0.5)
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Add a scroll view to contain the cards
        let scrollView = UIScrollView()
        contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // Add three cards
        let card1 = createCard()
        let card2 = createCard()
        let card3 = createCard()
        
        scrollView.addSubview(card1)
        scrollView.addSubview(card2)
        scrollView.addSubview(card3)
        
        card1.translatesAutoresizingMaskIntoConstraints = false
        card2.translatesAutoresizingMaskIntoConstraints = false
        card3.translatesAutoresizingMaskIntoConstraints = false
        
        card1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        card1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        card1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        card1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        card2.leadingAnchor.constraint(equalTo: card1.leadingAnchor).isActive = true
        card2.topAnchor.constraint(equalTo: card1.bottomAnchor, constant: 8).isActive = true
        card2.widthAnchor.constraint(equalTo: card1.widthAnchor).isActive = true
        card2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        card3.leadingAnchor.constraint(equalTo: card1.leadingAnchor).isActive = true
        card3.topAnchor.constraint(equalTo: card2.bottomAnchor, constant: 8).isActive = true
        card3.widthAnchor.constraint(equalTo: card1.widthAnchor).isActive = true
        card3.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        // Set the content size of the scroll view based on the height of the cards
        scrollView.contentSize = CGSize(width: 340, height: 80 * 3 + 8 * 2)
        
        blurEffectView.contentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Add some spacing between
        contentView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        return contentView
    }
    
    
    func createCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        card.layer.cornerRadius = 16
        
        let label = UILabel()
        label.text = "ABC"
        label.textColor = .white
        label.font = UIFont(name: "Barlow-Regular", size: 14)
        label.textAlignment = .center
        card.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        
        return card
    }
    
    
    func createContentView(with text: String) -> UIView {
        let contentView = UIView()
        contentView.isHidden = true
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.black
        label.textAlignment = .center
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        blurEffectView.contentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Add some spacing between
        contentView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        return contentView
    }
    
    func showContentView(at index: Int) {
        // Hide all content views first
        contentView1.isHidden = true
        contentView2.isHidden = true
        contentView3.isHidden = true
        contentView4.isHidden = true
        
        // Show the selected content view based on the index
        switch index {
        case 0:
            contentView1.isHidden = false
        case 1:
            contentView2.isHidden = false
        case 2:
            contentView3.isHidden = false
        case 3:
            contentView4.isHidden = false
        default:
            break
        }
    }
}
