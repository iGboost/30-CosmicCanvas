import UIKit

class WallpaperGeneratorViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let previewImageView = UIImageView()
    private let generateButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let settingsStackView = UIStackView()
    private let starfield = StarfieldView()
    
    private var currentWallpaper: UIImage?
    private var customColor: UIColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
    private var currentSeed: UInt64 = 0
    
    private let starDensitySlider = UISlider()
    private let nebulaIntensitySlider = UISlider()
    private let planetCountSlider = UISlider()
    private let colorSchemeSegment = UISegmentedControl(items: ["Purple", "Blue", "Green", "Orange", "Custom"])
    private let customColorButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        generateInitialWallpaper()
    }
    
    private func setupUI() {
        title = "Wallpaper Generator"
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupButtons()
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.layer.cornerRadius = 16
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        previewImageView.layer.borderWidth = 1
        previewImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        contentView.addSubview(previewImageView)
        
        setupControls()
        contentView.addSubview(settingsStackView)
    }
    
    private func setupControls() {
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 20
        settingsStackView.distribution = .fill
        
        let starSection = createSliderSection(title: "Star Density", slider: starDensitySlider, min: 0.1, max: 1.0, value: 0.5)
        let nebulaSection = createSliderSection(title: "Nebula Intensity", slider: nebulaIntensitySlider, min: 0.0, max: 1.0, value: 0.3)
        let planetSection = createSliderSection(title: "Planet Count", slider: planetCountSlider, min: 0, max: 5, value: 2)
        
        let colorSection = UIStackView()
        colorSection.axis = .vertical
        colorSection.spacing = 12
        
        let colorLabel = UILabel()
        colorLabel.text = "Color Scheme"
        colorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        colorLabel.textColor = .white
        
        colorSchemeSegment.selectedSegmentIndex = 0
        colorSchemeSegment.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        colorSchemeSegment.selectedSegmentTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        colorSchemeSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        colorSchemeSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        colorSchemeSegment.layer.cornerRadius = 8
        colorSchemeSegment.addTarget(self, action: #selector(colorSchemeChanged), for: .valueChanged)
        
        customColorButton.setTitle("Choose Color", for: .normal)
        customColorButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        customColorButton.setTitleColor(.white, for: .normal)
        customColorButton.layer.cornerRadius = 8
        customColorButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customColorButton.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
        customColorButton.isHidden = true
        customColorButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        colorSection.addArrangedSubview(colorLabel)
        colorSection.addArrangedSubview(colorSchemeSegment)
        colorSection.addArrangedSubview(customColorButton)
        
        [starSection, nebulaSection, planetSection, colorSection].forEach {
            settingsStackView.addArrangedSubview($0)
        }
        
        [starDensitySlider, nebulaIntensitySlider, planetCountSlider].forEach {
            $0.addTarget(self, action: #selector(settingsChanged), for: .valueChanged)
        }
    }
    
    private func createSliderSection(title: String, slider: UISlider, min: Float, max: Float, value: Float) -> UIStackView {
        let section = UIStackView()
        section.axis = .vertical
        section.spacing = 12
        
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        valueLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        valueLabel.text = String(format: "%.1f", value)
        
        headerStack.addArrangedSubview(label)
        headerStack.addArrangedSubview(valueLabel)
        
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = value
        slider.thumbTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        slider.minimumTrackTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        section.addArrangedSubview(headerStack)
        section.addArrangedSubview(slider)
        
        return section
    }
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        if let stackView = slider.superview as? UIStackView,
           let headerStack = stackView.arrangedSubviews.first as? UIStackView,
           let valueLabel = headerStack.arrangedSubviews.last as? UILabel {
            
            if slider == planetCountSlider {
                valueLabel.text = "\(Int(slider.value))"
            } else {
                valueLabel.text = String(format: "%.1f", slider.value)
            }
        }
        settingsChanged()
    }
    
    private func setupButtons() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
        generateButton.setTitle("Generate", for: .normal)
        generateButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        setupButton(generateButton, action: #selector(generateWallpaper))
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.2, green: 0.7, blue: 0.6, alpha: 1.0)
        setupButton(saveButton, action: #selector(saveWallpaper))
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.3, alpha: 1.0)
        setupButton(shareButton, action: #selector(shareWallpaper))
        
        [generateButton, saveButton, shareButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton(_ button: UIButton, action: Selector) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func setupConstraints() {
        [starfield, scrollView, contentView, previewImageView, settingsStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let buttonStackView = contentView.subviews.first!
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            
            previewImageView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            previewImageView.heightAnchor.constraint(equalToConstant: 300),
            
            settingsStackView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 24),
            settingsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            settingsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            settingsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func generateInitialWallpaper() {
        currentSeed = UInt64.random(in: 0...UInt64.max)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.generateWallpaper()
        }
    }
    
    @objc private func settingsChanged() {
        currentSeed = UInt64.random(in: 0...UInt64.max)
        generateWallpaper()
    }
    
    @objc private func colorSchemeChanged() {
        customColorButton.isHidden = colorSchemeSegment.selectedSegmentIndex != 4
        if colorSchemeSegment.selectedSegmentIndex != 4 {
            generateWallpaper()
        }
    }
    
    @objc private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        present(colorPicker, animated: true)
    }
    
    @objc private func generateWallpaper() {
        let generator = CosmicWallpaperGenerator()
        
        let colorScheme: ColorScheme
        if colorSchemeSegment.selectedSegmentIndex == 4 {
            colorScheme = .custom(customColor)
        } else {
            colorScheme = [ColorScheme.purple, .blue, .green, .orange][colorSchemeSegment.selectedSegmentIndex]
        }
        
        let settings = WallpaperSettings(
            starDensity: starDensitySlider.value,
            nebulaIntensity: nebulaIntensitySlider.value,
            planetCount: Int(planetCountSlider.value),
            colorScheme: colorScheme,
            seed: currentSeed
        )
        
        generateButton.isEnabled = false
        generateButton.setTitle("Generating...", for: .normal)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let wallpaper = generator.generateWallpaper(settings: settings, size: CGSize(width: 1170, height: 2532))
            
            DispatchQueue.main.async {
                self.currentWallpaper = wallpaper
                self.previewImageView.image = wallpaper
                self.generateButton.isEnabled = true
                self.generateButton.setTitle("Generate", for: .normal)
                
                UIView.transition(with: self.previewImageView, duration: 0.3, options: .transitionCrossDissolve) {
                    self.previewImageView.image = wallpaper
                } completion: { _ in
                    self.animatePreview()
                }
            }
        }
    }
    
    private func animatePreview() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3) {
            self.previewImageView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.previewImageView.transform = .identity
            }
        }
    }
    
    @objc private func saveWallpaper() {
        guard let image = currentWallpaper else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc private func shareWallpaper() {
        guard let image = currentWallpaper else { return }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = shareButton
        present(activityVC, animated: true)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(
            title: error == nil ? "Saved!" : "Error",
            message: error == nil ? "Wallpaper saved to Photos" : "Failed to save wallpaper",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension WallpaperGeneratorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        customColor = viewController.selectedColor
        customColorButton.backgroundColor = customColor.withAlphaComponent(0.3)
        customColorButton.setTitle("Color Selected", for: .normal)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        customColor = viewController.selectedColor
        customColorButton.backgroundColor = customColor.withAlphaComponent(0.3)
        generateWallpaper()
    }
}