import UIKit

class SpaceCalculatorViewController: UIViewController {
    
    private let utility: SpaceUtility
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let starfield = StarfieldView()
    private let calculatorView = UIView()
    
    init(utility: SpaceUtility) {
        self.utility = utility
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCalculator()
        setupConstraints()
    }
    
    private func setupUI() {
        title = utility.title
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(calculatorView)
        
        calculatorView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        calculatorView.layer.cornerRadius = 16
    }
    
    private func setupCalculator() {
        switch utility.type {
        case .distance:
            setupDistanceCalculator()
        case .time:
            setupTimeConverter()
        case .mass:
            setupMassCalculator()
        case .lightSpeed:
            setupLightSpeedCalculator()
        case .orbital:
            setupOrbitalCalculator()
        case .temperature:
            setupTemperatureConverter()
        }
    }
    
    private func setupDistanceCalculator() {
        let titleLabel = createTitleLabel("Distance Calculator")
        let descLabel = createDescriptionLabel("Calculate distances between celestial objects")
        
        let input1 = createInputField(placeholder: "Enter distance in km")
        let segmentControl = UISegmentedControl(items: ["km", "AU", "Light Years", "Parsecs"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        segmentControl.selectedSegmentTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.calculateDistance(input: input1.text ?? "", unit: segmentControl.selectedSegmentIndex)
        }
        
        let resultLabel = createResultLabel()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, segmentControl, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupTimeConverter() {
        let titleLabel = createTitleLabel("Time Converter")
        let descLabel = createDescriptionLabel("Convert between Earth time and space time")
        
        let input1 = createInputField(placeholder: "Enter time value")
        let fromSegment = UISegmentedControl(items: ["Seconds", "Minutes", "Hours", "Days", "Years"])
        let toSegment = UISegmentedControl(items: ["Seconds", "Minutes", "Hours", "Days", "Years"])
        
        [fromSegment, toSegment].forEach { segment in
            segment.selectedSegmentIndex = 0
            segment.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            segment.selectedSegmentTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
            segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.convertTime(input: input1.text ?? "", from: fromSegment.selectedSegmentIndex, to: toSegment.selectedSegmentIndex)
        }
        
        let resultLabel = createResultLabel()
        
        let fromLabel = UILabel()
        fromLabel.text = "From:"
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        fromLabel.textColor = .white
        
        let toLabel = UILabel()
        toLabel.text = "To:"
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        toLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, fromLabel, fromSegment, toLabel, toSegment, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupMassCalculator() {
        let titleLabel = createTitleLabel("Mass Calculator")
        let descLabel = createDescriptionLabel("Calculate planetary and stellar masses")
        
        let input1 = createInputField(placeholder: "Enter mass in kg")
        let resultLabel = createResultLabel()
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.calculateMass(input: input1.text ?? "")
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupLightSpeedCalculator() {
        let titleLabel = createTitleLabel("Light Speed Calculator")
        let descLabel = createDescriptionLabel("Calculate light travel times")
        
        let input1 = createInputField(placeholder: "Enter distance in light years")
        let resultLabel = createResultLabel()
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.calculateLightSpeed(input: input1.text ?? "")
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupOrbitalCalculator() {
        let titleLabel = createTitleLabel("Orbital Period Calculator")
        let descLabel = createDescriptionLabel("Calculate orbital periods of planets")
        
        let input1 = createInputField(placeholder: "Enter semi-major axis (AU)")
        let resultLabel = createResultLabel()
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.calculateOrbitalPeriod(input: input1.text ?? "")
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupTemperatureConverter() {
        let titleLabel = createTitleLabel("Temperature Converter")
        let descLabel = createDescriptionLabel("Convert between temperature scales")
        
        let input1 = createInputField(placeholder: "Enter temperature")
        let fromSegment = UISegmentedControl(items: ["Celsius", "Fahrenheit", "Kelvin"])
        let toSegment = UISegmentedControl(items: ["Celsius", "Fahrenheit", "Kelvin"])
        
        [fromSegment, toSegment].forEach { segment in
            segment.selectedSegmentIndex = 0
            segment.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            segment.selectedSegmentTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
            segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
        
        let calculateButton = createCalculateButton { [weak self] in
            self?.convertTemperature(input: input1.text ?? "", from: fromSegment.selectedSegmentIndex, to: toSegment.selectedSegmentIndex)
        }
        
        let resultLabel = createResultLabel()
        
        let fromLabel = UILabel()
        fromLabel.text = "From:"
        fromLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        fromLabel.textColor = .white
        
        let toLabel = UILabel()
        toLabel.text = "To:"
        toLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        toLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, input1, fromLabel, fromSegment, toLabel, toSegment, calculateButton, resultLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        calculatorView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: calculatorView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: calculatorView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: calculatorView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: calculatorView.bottomAnchor, constant: -24)
        ])
        
        resultLabel.tag = 100
    }
    
    private func setupConstraints() {
        [starfield, scrollView, contentView, calculatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            calculatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            calculatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calculatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calculatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private func createDescriptionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    private func createInputField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textField.textColor = .white
        textField.layer.cornerRadius = 8
        textField.keyboardType = .decimalPad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }
    
    private func createCalculateButton(action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }
    
    private func createResultLabel() -> UILabel {
        let label = UILabel()
        label.text = "Result will appear here"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    private func calculateDistance(input: String, unit: Int) {
        guard let distance = Double(input), distance > 0 else {
            showResult("Please enter a valid distance")
            return
        }
        
        let conversions = [
            "km": distance,
            "AU": distance / 149597870.7,
            "Light Years": distance / 9.461e12,
            "Parsecs": distance / 3.086e13
        ]
        
        let units = ["km", "AU", "Light Years", "Parsecs"]
        let selectedUnit = units[unit]
        
        var results: [String] = []
        for (unitName, value) in conversions {
            if unitName != selectedUnit {
                results.append("\(formatNumber(value)) \(unitName)")
            }
        }
        
        showResult("Conversions:\n" + results.joined(separator: "\n"))
    }
    
    private func convertTime(input: String, from: Int, to: Int) {
        guard let time = Double(input), time > 0 else {
            showResult("Please enter a valid time value")
            return
        }
        
        let toSeconds = [1.0, 60.0, 3600.0, 86400.0, 31557600.0]
        let units = ["Seconds", "Minutes", "Hours", "Days", "Years"]
        
        let timeInSeconds = time * toSeconds[from]
        let convertedTime = timeInSeconds / toSeconds[to]
        
        showResult("\(formatNumber(convertedTime)) \(units[to])")
    }
    
    private func calculateMass(input: String) {
        guard let mass = Double(input), mass > 0 else {
            showResult("Please enter a valid mass")
            return
        }
        
        let earthMass = 5.972e24
        let sunMass = 1.989e30
        
        let earthMasses = mass / earthMass
        let sunMasses = mass / sunMass
        
        showResult("Earth Masses: \(formatNumber(earthMasses))\nSun Masses: \(formatNumber(sunMasses))")
    }
    
    private func calculateLightSpeed(input: String) {
        guard let lightYears = Double(input), lightYears > 0 else {
            showResult("Please enter a valid distance")
            return
        }
        
        let timeInYears = lightYears
        let timeInDays = lightYears * 365.25
        let timeInHours = timeInDays * 24
        
        showResult("Light travel time:\n\(formatNumber(timeInYears)) years\n\(formatNumber(timeInDays)) days\n\(formatNumber(timeInHours)) hours")
    }
    
    private func calculateOrbitalPeriod(input: String) {
        guard let semiMajorAxis = Double(input), semiMajorAxis > 0 else {
            showResult("Please enter a valid semi-major axis")
            return
        }
        
        let period = pow(semiMajorAxis, 1.5)
        let periodInDays = period * 365.25
        
        showResult("Orbital Period:\n\(formatNumber(period)) Earth years\n\(formatNumber(periodInDays)) days")
    }
    
    private func convertTemperature(input: String, from: Int, to: Int) {
        guard let temp = Double(input) else {
            showResult("Please enter a valid temperature")
            return
        }
        
        var celsius: Double
        
        switch from {
        case 0:
            celsius = temp
        case 1:
            celsius = (temp - 32) * 5/9
        case 2:
            celsius = temp - 273.15
        default:
            celsius = temp
        }
        
        var result: Double
        var unit: String
        
        switch to {
        case 0:
            result = celsius
            unit = "°C"
        case 1:
            result = celsius * 9/5 + 32
            unit = "°F"
        case 2:
            result = celsius + 273.15
            unit = "K"
        default:
            result = celsius
            unit = "°C"
        }
        
        showResult("\(formatNumber(result)) \(unit)")
    }
    
    private func showResult(_ text: String) {
        if let resultLabel = calculatorView.viewWithTag(100) as? UILabel {
            resultLabel.text = text
            
            UIView.animate(withDuration: 0.3) {
                resultLabel.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    resultLabel.transform = .identity
                }
            }
        }
    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}