import UIKit

class UtilitiesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let starfield = StarfieldView()
    
    private let utilities: [SpaceUtility] = [
        SpaceUtility(title: "Distance Calculator", subtitle: "Calculate distances between celestial objects", icon: "ruler.fill", type: .distance),
        SpaceUtility(title: "Time Converter", subtitle: "Convert between Earth time and space time", icon: "clock.fill", type: .time),
        SpaceUtility(title: "Mass Calculator", subtitle: "Calculate planetary and stellar masses", icon: "scalemass.fill", type: .mass),
        SpaceUtility(title: "Light Speed Calculator", subtitle: "Calculate light travel times", icon: "bolt.fill", type: .lightSpeed),
        SpaceUtility(title: "Orbital Period", subtitle: "Calculate orbital periods of planets", icon: "globe.americas.fill", type: .orbital),
        SpaceUtility(title: "Temperature Converter", subtitle: "Convert between temperature scales", icon: "thermometer.medium", type: .temperature)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        title = "Space Tools"
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UtilityCell.self, forCellReuseIdentifier: "UtilityCell")
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        [starfield, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UtilitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UtilityCell", for: indexPath) as! UtilityCell
        cell.configure(with: utilities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let utility = utilities[indexPath.row]
        let calculatorVC = SpaceCalculatorViewController(utility: utility)
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
}

class UtilityCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        addSubview(containerView)
        
        iconImageView.tintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        
        [containerView, iconImageView, titleLabel, subtitleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with utility: SpaceUtility) {
        iconImageView.image = UIImage(systemName: utility.icon)
        titleLabel.text = utility.title
        subtitleLabel.text = utility.subtitle
    }
}

struct SpaceUtility {
    let title: String
    let subtitle: String
    let icon: String
    let type: UtilityType
}

enum UtilityType {
    case distance, time, mass, lightSpeed, orbital, temperature
}