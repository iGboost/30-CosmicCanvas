import UIKit

class PlanetDetailViewController: UIViewController {
    
    private let planet: Planet
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let starfield = StarfieldView()
    
    private let planetView = UIView()
    private let nameLabel = UILabel()
    private let emojiLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statsStackView = UIStackView()
    private let factsStackView = UIStackView()
    
    init(planet: Planet) {
        self.planet = planet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configurePlanet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animatePlanet()
    }
    
    private func setupUI() {
        title = planet.name
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        planetView.backgroundColor = planet.color
        planetView.layer.shadowColor = UIColor.black.cgColor
        planetView.layer.shadowOpacity = 0.5
        planetView.layer.shadowOffset = CGSize(width: 0, height: 10)
        planetView.layer.shadowRadius = 20
        contentView.addSubview(planetView)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 60)
        emojiLabel.textAlignment = .center
        planetView.addSubview(emojiLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        statsStackView.axis = .vertical
        statsStackView.spacing = 16
        statsStackView.distribution = .fill
        contentView.addSubview(statsStackView)
        
        factsStackView.axis = .vertical
        factsStackView.spacing = 12
        factsStackView.distribution = .fill
        contentView.addSubview(factsStackView)
    }
    
    private func setupConstraints() {
        [starfield, scrollView, contentView, planetView, emojiLabel, nameLabel, descriptionLabel, statsStackView, factsStackView].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        let planetSize: CGFloat = 200
        
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
            
            planetView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            planetView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            planetView.widthAnchor.constraint(equalToConstant: planetSize),
            planetView.heightAnchor.constraint(equalToConstant: planetSize),
            
            emojiLabel.centerXAnchor.constraint(equalTo: planetView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: planetView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: planetView.bottomAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            factsStackView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            factsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            factsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            factsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func configurePlanet() {
        planetView.backgroundColor = .clear
        
        emojiLabel.text = ""
        
        let iconView = UIImageView()
        let imageName = planet.name.replacingOccurrences(of: "'s", with: "s")
        if let image = UIImage(named: imageName) {
            iconView.image = image.withRenderingMode(.alwaysOriginal)
        }
        iconView.contentMode = .scaleAspectFit
        planetView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: planetView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: planetView.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: planetView.widthAnchor, multiplier: 0.9),
            iconView.heightAnchor.constraint(equalTo: planetView.heightAnchor, multiplier: 0.9)
        ])
        nameLabel.text = planet.name
        descriptionLabel.text = planet.description
        
        // Stats
        let stats = [
            ("Distance from Sun", "\(Int(planet.distanceFromSun)) million km"),
            ("Orbital Period", "\(Int(planet.orbitalPeriod)) Earth days"),
            ("Day Length", "\(planet.dayLength) hours"),
            ("Moons", "\(planet.moons)"),
            ("Temperature", "\(planet.temperature.lowerBound)°C to \(planet.temperature.upperBound)°C")
        ]
        
        for stat in stats {
            statsStackView.addArrangedSubview(createStatView(title: stat.0, value: stat.1))
        }
        
        // Facts
        let factsLabel = UILabel()
        factsLabel.text = "Interesting Facts"
        factsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        factsLabel.textColor = .white
        factsStackView.addArrangedSubview(factsLabel)
        
        for fact in planet.facts {
            factsStackView.addArrangedSubview(createFactView(text: fact))
        }
    }
    
    private func createStatView(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        [titleLabel, valueLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
        
        return container
    }
    
    private func createFactView(text: String) -> UIView {
        let container = UIView()
        
        let bulletLabel = UILabel()
        bulletLabel.text = "•"
        bulletLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bulletLabel.textColor = planet.color
        
        let factLabel = UILabel()
        factLabel.text = text
        factLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        factLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        factLabel.numberOfLines = 0
        
        container.addSubview(bulletLabel)
        container.addSubview(factLabel)
        
        [bulletLabel, factLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            bulletLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            bulletLabel.topAnchor.constraint(equalTo: container.topAnchor),
            bulletLabel.widthAnchor.constraint(equalToConstant: 20),
            
            factLabel.leadingAnchor.constraint(equalTo: bulletLabel.trailingAnchor),
            factLabel.topAnchor.constraint(equalTo: container.topAnchor),
            factLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            factLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func animatePlanet() {
        // Initial animation only
        planetView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        planetView.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3) {
            self.planetView.transform = .identity
            self.planetView.alpha = 1
        }
    }
}