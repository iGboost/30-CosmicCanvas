import UIKit

class PlanetsViewController: UIViewController {
    
    private let collectionView: UICollectionView
    private let starfield = StarfieldView()
    private let segmentedControl = UISegmentedControl(items: ["All", "Planets", "Dwarf", "Asteroids", "Comets"])
    private var allObjects: [Planet] = Planet.allPlanets
    private var filteredObjects: [Planet] = Planet.allPlanets
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        title = "Solar System"
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        segmentedControl.selectedSegmentTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        view.addSubview(segmentedControl)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlanetCell.self, forCellWithReuseIdentifier: "PlanetCell")
        view.addSubview(collectionView)
    }
    
    @objc private func filterChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // All
            filteredObjects = allObjects
        case 1: // Planets
            filteredObjects = allObjects.filter { !["pluto", "ceres", "eris", "makemake", "asteroid-belt", "vesta", "halley", "hale-bopp"].contains($0.id) && $0.id != "sun" }
        case 2: // Dwarf Planets
            filteredObjects = allObjects.filter { ["pluto", "ceres", "eris", "makemake"].contains($0.id) }
        case 3: // Asteroids
            filteredObjects = allObjects.filter { ["asteroid-belt", "vesta"].contains($0.id) }
        case 4: // Comets
            filteredObjects = allObjects.filter { ["halley", "hale-bopp"].contains($0.id) }
        default:
            filteredObjects = allObjects
        }
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        [starfield, segmentedControl, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PlanetsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as! PlanetCell
        cell.configure(with: filteredObjects[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 56) / 2
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let planet = filteredObjects[indexPath.item]
        let detailVC = PlanetDetailViewController(planet: planet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class PlanetCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let planetView = UIView()
    private let nameLabel = UILabel()
    private let distanceLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear previous planet icon
        for subview in planetView.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        // Disable selection highlighting
        selectedBackgroundView = UIView()
        backgroundView = UIView()
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        planetView.layer.shadowColor = UIColor.black.cgColor
        planetView.layer.shadowOpacity = 0.3
        planetView.layer.shadowOffset = CGSize(width: 0, height: 4)
        planetView.layer.shadowRadius = 8
        containerView.addSubview(planetView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)
        
        distanceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        distanceLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        distanceLabel.textAlignment = .center
        containerView.addSubview(distanceLabel)
        
        [containerView, planetView, nameLabel, distanceLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            planetView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            planetView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            planetView.widthAnchor.constraint(equalToConstant: 80),
            planetView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -4),
            
            distanceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            distanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            distanceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with planet: Planet) {
        nameLabel.text = planet.name
        distanceLabel.text = "\(Int(planet.distanceFromSun))M km from Sun"
        
        planetView.backgroundColor = .clear
        
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
        
    }
}