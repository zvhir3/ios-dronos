import UIKit

final class DenseContentSheetViewController: BottomSheetController {
    
    var missionDetail: APIService.Mission!
    
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
        titleLabel.attributedText = NSMutableAttributedString(string: missionDetail.name, attributes: [NSAttributedString.Key.kern: 0.72, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
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
        //        temporary hardcoded id = MN1691046870657
        let label = UILabel()
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        label.font = UIFont(name: "Barlow-Regular", size: 12)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        label.attributedText = NSMutableAttributedString(string: missionDetail.missionId, attributes: [NSAttributedString.Key.kern: 4, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
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
        contentView2 = createContentViewOperator()
        contentView3 = createContentViewDrone()
//        contentView2 = createContentView(with: "Content for Tab 2")
//        contentView3 = createContentView(with: "Content for Tab 3")
        contentView4 = createContentView(with: "Content for Tab 4")
        
        // Show the initial content view based on the initially selected segment
        showContentView(at: segmentedControl.selectedSegmentIndex)
    }
    

    @objc func segmentedControlValueChanged() {
        // Show the corresponding content view when the segmented control value changes
        showContentView(at: segmentedControl.selectedSegmentIndex)
    }
    
    // DRONE LIST LOGIC
    func createContentViewDrone() -> UIView {
        let droneView = UIView()
        droneView.isHidden = true
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.26
        titleLabel.attributedText = NSMutableAttributedString(string: "EQUIPMENT DETAIL", attributes: [NSAttributedString.Key.kern: 4, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        droneView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: droneView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: droneView.topAnchor, constant: 0).isActive = true
        
        // Add the separator line
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 0.376, green: 0.431, blue: 0.475, alpha: 0.5)
        droneView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: droneView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: droneView.trailingAnchor, constant: -16).isActive = true
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        let scrollView = UIScrollView()
        droneView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: droneView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: droneView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: droneView.bottomAnchor, constant: -8).isActive = true
        
        blurEffectView.contentView.addSubview(droneView)
        droneView.translatesAutoresizingMaskIntoConstraints = false
        droneView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor).isActive = true
        droneView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        droneView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Add some spacing between
        droneView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16).isActive = true
        
        let columnCount = 2
        let spacing: CGFloat = 16
        let cardWidth: CGFloat = 180
        let cardHeight: CGFloat = 180

        var cards: [UIView] = []
        
        
        var itu = [DronosUTM.APIService.Drones(model: "Matrice M200", name: "Drone 01"), DronosUTM.APIService.Drones(model: "Matrice M200", name: "Drone 01"), DronosUTM.APIService.Drones(model: "Matrice M200", name: "Drone 01")]

        for (idx, drone) in itu.enumerated() {
            let card = createCardDrone(drones: drone)
            scrollView.addSubview(card)
            cards.append(card)
            card.translatesAutoresizingMaskIntoConstraints = false
            
            let rowIndex = idx / columnCount
            let columnIndex = idx % columnCount
            
            let xOffset = CGFloat(columnIndex) * (cardWidth + spacing)
            let yOffset = CGFloat(rowIndex) * (cardHeight + spacing)

            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16 + xOffset),
                card.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10 + yOffset),
                card.widthAnchor.constraint(equalToConstant: cardWidth),
                card.heightAnchor.constraint(equalToConstant: cardHeight)
            ])
        }
        
        let totalRows = ceil(CGFloat(itu.count) / CGFloat(columnCount))
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: (cardHeight + spacing) * totalRows + spacing)
        
        return droneView
    }
    // OPERATOR LIST LOGIC
    func createContentViewOperator() -> UIView {
        let operatorView = UIView()
        operatorView.isHidden = true
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel.font = UIFont(name: "Barlow-Regular", size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.26
        titleLabel.attributedText = NSMutableAttributedString(string: "OPERATOR DETAIL", attributes: [NSAttributedString.Key.kern: 4, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        operatorView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: operatorView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: operatorView.topAnchor, constant: 0).isActive = true
        
        // Add the separator line
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 0.376, green: 0.431, blue: 0.475, alpha: 0.5)
        operatorView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: operatorView.leadingAnchor, constant: 16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: operatorView.trailingAnchor, constant: -16).isActive = true
        separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let scrollView = UIScrollView()
        operatorView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: operatorView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: operatorView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: operatorView.bottomAnchor, constant: -8).isActive = true
        
        var card1 = UIView()
        for _ in 0..<2 {
            card1 = createCardOperator()
        }
        
        scrollView.addSubview(card1)
        
        
        card1.translatesAutoresizingMaskIntoConstraints = false
        
        card1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        card1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        card1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        card1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        blurEffectView.contentView.addSubview(operatorView)
        operatorView.translatesAutoresizingMaskIntoConstraints = false
        operatorView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor).isActive = true
        operatorView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        operatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Add some spacing between
        operatorView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16).isActive = true
        
        return operatorView
    }
    
    
    
    // SCHEDULE LIST LOGIC
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
        
        let today = Date()
        
        let upcoming = missionDetail.schedules.filter { schedule in
            
            let givenDate = convertToISODate(schedule.startDate)
            
            print("-----------------------")
            print(givenDate, schedule.startDate)
            
            if let givenDate = convertToISODate(schedule.startDate) {
              
                let currentDate = Date()
                
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: currentDate)
                let startDate = calendar.startOfDay(for: givenDate)

                if startDate > today {
                    print("The given date is in the future.")
                } else if startDate < today {
                    print("The given date is in the past.")
                } else {
                    print("The given date is today.")
                }
            } else {
                print("Failed to convert given date string to Date object.")
            }
            return true
        }
        
        let todaySchedules = missionDetail.schedules.filter { schedule in
//            let scheduleStartDate = convertToDate(schedule.startDate)
//            print("upcoming", Calendar.current.isDate(today, inSameDayAs: scheduleStartDate), scheduleStartDate)
            return false
        }
        
        //today's mission
        let titleLabel1 = UILabel()
        titleLabel1.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel1.font = UIFont.systemFont(ofSize: 12)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineHeightMultiple = 2.26
        titleLabel1.attributedText = NSMutableAttributedString(string: "Today's Mission", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle1])
        
        contentView.addSubview(titleLabel1)
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel1.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        
        // Add a scroll view to contain the cards
        let scrollView = UIScrollView()
        contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        
        var card1 = UIView()
        for (idx, schedule) in todaySchedules.enumerated() {
            let adjustedIdx = idx + 1
            card1 = createCard(schedule: schedule, missionId: missionDetail.missionId, idx: String(adjustedIdx))
        }
        
        scrollView.addSubview(card1)
        
        
        card1.translatesAutoresizingMaskIntoConstraints = false
        
        card1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        card1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        card1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        card1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let badge = createBadge(withText: "COMPLETED")
        scrollView.addSubview(badge)
        
        // Set constraints for badge
        badge.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badge.topAnchor.constraint(equalTo: card1.topAnchor, constant: 8), // This positions the badge 10 points below the card
            badge.leadingAnchor.constraint(equalTo: card1.trailingAnchor, constant: -73), // This positions the badge 10 points to the right of the card
            badge.widthAnchor.constraint(equalToConstant: 80), // Adjust badge width as needed
            badge.heightAnchor.constraint(equalToConstant: 20) // Assuming badge is a circle
        ])
        
        scrollView.contentSize = CGSize(width: 340, height: 80 * 3 + 8 * 2)
        
        let titleLabel2 = UILabel()
        titleLabel2.textColor = UIColor(red: 0.933, green: 0.957, blue: 0.969, alpha: 1)
        titleLabel2.font = UIFont.systemFont(ofSize: 12)
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineHeightMultiple = 2.26
        titleLabel2.attributedText = NSMutableAttributedString(string: "Next Mission", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        
        contentView.addSubview(titleLabel2)
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel2.topAnchor.constraint(equalTo: card1.bottomAnchor, constant: 10).isActive = true // Adjust this value if you want a different spacing
        
        let scrollView2 = UIScrollView()
        contentView.addSubview(scrollView2)
        scrollView2.translatesAutoresizingMaskIntoConstraints = false
        scrollView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: 8).isActive = true
        scrollView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        
        
        var card2 = UIView()
        for (idx, schedule) in upcoming.enumerated() { // Assuming this, adjust the loop if you want a different data
            let adjustedIdx = idx + 1
            card2 = createCard(schedule: schedule, missionId: missionDetail.missionId, idx: String(adjustedIdx))
        }
        scrollView.addSubview(card2)
        
        card2.translatesAutoresizingMaskIntoConstraints = false
        
        card2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        card2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: 10).isActive = true
        card2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        card2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let badge2 = createBadge(withText: "UPCOMING")
        scrollView.addSubview(badge2)
        
        badge2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badge2.topAnchor.constraint(equalTo: card2.topAnchor, constant: 8),
            badge2.leadingAnchor.constraint(equalTo: card2.trailingAnchor, constant: -73),
            badge2.widthAnchor.constraint(equalToConstant: 80),
            badge2.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Set the content size of the scroll view based on the height of the cards
        
        scrollView2.contentSize = CGSize(width: 340, height: 80 * 3 + 8 * 2)
        
        blurEffectView.contentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true // Add some spacing between
        contentView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -16).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant:  150).isActive = true
        
        return contentView
    }
    
    func convertToISODate(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        
        return( formatter.date(from: dateString))
    }
    
    func createBadge(withText text: String) -> UIView {
        let badge = UIView()
        badge.backgroundColor = UIColor(red: 0.4, green: 0.84, blue: 0.65, alpha: 0.2) // Badge color
        badge.layer.cornerRadius = 4 // Assuming badge is a circle
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 0.4, green: 0.84, blue: 0.65, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        
        badge.addSubview(label)
        
        // Setting constraints for label inside badge
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: badge.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -5)
        ])
        
        return badge
    }
    
    // OPERATOR LIST CARD
    func createCardOperator() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.22, green: 0.25, blue: 0.3, alpha: 0.8)
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0, height: 11)
        containerView.layer.shadowRadius = 10
        
        let hView = UIStackView()
        hView.axis = .horizontal
        hView.alignment = .center // This will ensure the image and the labels are aligned centrally.
        hView.spacing = 16
        hView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hView)

        // Constraints for hView
        NSLayoutConstraint.activate([
            hView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            hView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            hView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            hView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])

        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-photo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: hView.leadingAnchor, constant: 8).isActive = true // Left padding for the image
        hView.addArrangedSubview(imageView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        hView.addArrangedSubview(stackView) // Add stackView to hView

        let nameLabel = UILabel()
        nameLabel.text = "NADHIRAH"
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        stackView.addArrangedSubview(nameLabel)

        let emailLabel = UILabel()
        emailLabel.text = "nad@gmail.com"
        emailLabel.font = UIFont.systemFont(ofSize: 10)
        emailLabel.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        stackView.addArrangedSubview(emailLabel)
        
       
        return containerView
    }
    
    // DRONE LIST CARD
    func createCardDrone(drones: APIService.Drones) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.22, green: 0.25, blue: 0.3, alpha: 0.8)
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0, height: 11)
        containerView.layer.shadowRadius = 10
//        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        containerView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "drone-img")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(imageView)
        
        
        let droneModel = UILabel()
        droneModel.text = drones.model
        droneModel.font = UIFont.systemFont(ofSize: 10)
        droneModel.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        stackView.addArrangedSubview(droneModel)
        
        let droneName = UILabel()
        droneName.text = drones.name
        droneName.font = UIFont.systemFont(ofSize: 10)
        droneName.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        droneName.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 7 // Adjust as needed

        // Container view
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        badgeView.layer.cornerRadius = 6 // Adjust as needed for the desired corner radius
        badgeView.clipsToBounds = true

        // Add the label to the container
        badgeView.addSubview(droneName)
        stackView.addArrangedSubview(badgeView)

        // Constraints for padding
        NSLayoutConstraint.activate([
            droneName.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: padding),
            droneName.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -padding),
            droneName.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: padding),
            droneName.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -padding)
        ])
        
        return containerView
    }
    
    // SCHEDULE LIST CARD
    func createCard(schedule: APIService.Schedule, missionId: String, idx: String) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.22, green: 0.25, blue: 0.3, alpha: 0.8)
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0, height: 11)
        containerView.layer.shadowRadius = 10
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 4
        hStackView.alignment = .center
        
        let nameLabel = UILabel()
        nameLabel.text = "Schedule " + idx
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = .white
        hStackView.addArrangedSubview(nameLabel)
        
        let dotImageView = UIImageView(image: UIImage(named: "dot"))
        dotImageView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        dotImageView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        hStackView.addArrangedSubview(dotImageView)
        
        let missionIdLabel = UILabel()
        missionIdLabel.text = missionId
        missionIdLabel.font = UIFont.systemFont(ofSize: 10)
        missionIdLabel.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
        hStackView.addArrangedSubview(missionIdLabel)
        
        stackView.addArrangedSubview(hStackView)
        
        let dateLabel = UILabel()
        dateLabel.text = "\(formattedDate(from: schedule.startDate)) - \(formattedDate(from: schedule.endDate))"
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        stackView.addArrangedSubview(dateLabel)
        
        let scheduleLabel = UILabel()
        scheduleLabel.text = "\(formatTime(schedule.startTime)) - \(formatTime(schedule.endTime))"
        scheduleLabel.font = UIFont.systemFont(ofSize: 10)
        scheduleLabel.textColor = UIColor(red: 0.69, green: 0.75, blue: 0.77, alpha: 1.0)
        stackView.addArrangedSubview(scheduleLabel)
        
        return containerView
        
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
