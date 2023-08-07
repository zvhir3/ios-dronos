import UIKit

class FloatingActionButton: UIButton {

    private let buttonSize: CGFloat = 56

    var tapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }

    private func configureButton() {
        layer.cornerRadius = buttonSize / 2
        backgroundColor = UIColor.systemBlue
        setImage(UIImage(systemName: "plus"), for: .normal)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        tapHandler?()
    }
}
