import UIKit

struct Achievement {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let isUnlocked: Bool
    let color: UIColor
}

class AchievementsViewController: UIViewController {
    
    private let starfield = StarfieldView()
    private let tableView = UITableView()
    private let headerView = UIView()
    private let progressCircle = CircularProgressView()
    private let completionLabel = UILabel()
    
    private var achievements: [Achievement] = [
        Achievement(
            id: "first_quiz",
            title: "First Steps",
            description: "Complete your first quiz",
            emoji: "🚀",
            isUnlocked: false,
            color: UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)
        ),
        Achievement(
            id: "planets_master",
            title: "Planets Master",
            description: "Complete all planet quizzes",
            emoji: "🪐",
            isUnlocked: false,
            color: UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        ),
        Achievement(
            id: "sun_expert",
            title: "Sun Expert",
            description: "Master our star's secrets",
            emoji: "☀️",
            isUnlocked: false,
            color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        ),
        Achievement(
            id: "dwarf_specialist",
            title: "Dwarf Planet Specialist",
            description: "Learn about dwarf planets",
            emoji: "🌑",
            isUnlocked: false,
            color: UIColor(red: 0.7, green: 0.5, blue: 0.8, alpha: 1.0)
        ),
        Achievement(
            id: "asteroid_hunter",
            title: "Asteroid Hunter",
            description: "Explore rocky space objects",
            emoji: "🪨",
            isUnlocked: false,
            color: UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0)
        ),
        Achievement(
            id: "comet_chaser",
            title: "Comet Chaser",
            description: "Track icy space visitors",
            emoji: "☄️",
            isUnlocked: false,
            color: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
        ),
        Achievement(
            id: "inner_planets",
            title: "Inner System Explorer",
            description: "Master Mercury, Venus, Earth, Mars",
            emoji: "🔥",
            isUnlocked: true,
            color: UIColor(red: 0.9, green: 0.4, blue: 0.2, alpha: 1.0)
        ),
        Achievement(
            id: "outer_planets",
            title: "Outer System Expert",
            description: "Conquer Jupiter, Saturn, Uranus, Neptune",
            emoji: "❄️",
            isUnlocked: false,
            color: UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        ),
        Achievement(
            id: "moon_master",
            title: "Moon Master",
            description: "Learn about planetary moons",
            emoji: "🌙",
            isUnlocked: false,
            color: UIColor(red: 0.8, green: 0.8, blue: 0.9, alpha: 1.0)
        ),
        Achievement(
            id: "temperature_expert",
            title: "Temperature Expert",
            description: "Master planetary temperatures",
            emoji: "🌡️",
            isUnlocked: false,
            color: UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        ),
        Achievement(
            id: "distance_scholar",
            title: "Distance Scholar",
            description: "Know all orbital distances",
            emoji: "📏",
            isUnlocked: true,
            color: UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)
        ),
        Achievement(
            id: "solar_system_master",
            title: "Solar System Master",
            description: "Complete all categories",
            emoji: "🌌",
            isUnlocked: false,
            color: UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0)
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateProgress()
    }
    
    private func setupUI() {
        title = "Progress"
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        headerView.backgroundColor = .clear
        view.addSubview(headerView)
        
        progressCircle.lineWidth = 8
        progressCircle.trackColor = UIColor.white.withAlphaComponent(0.2)
        progressCircle.progressColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        headerView.addSubview(progressCircle)
        
        completionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        completionLabel.textColor = .white
        completionLabel.textAlignment = .center
        completionLabel.numberOfLines = 2
        headerView.addSubview(completionLabel)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AchievementCell.self, forCellReuseIdentifier: "AchievementCell")
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        [starfield, headerView, progressCircle, completionLabel, tableView].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            progressCircle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            progressCircle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            progressCircle.widthAnchor.constraint(equalToConstant: 80),
            progressCircle.heightAnchor.constraint(equalToConstant: 80),
            
            completionLabel.leadingAnchor.constraint(equalTo: progressCircle.trailingAnchor, constant: 20),
            completionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            completionLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateProgress() {
        let unlockedCount = achievements.filter { $0.isUnlocked }.count
        let progress = Double(unlockedCount) / Double(achievements.count)
        
        progressCircle.setProgress(progress, animated: true)
        completionLabel.text = "\(unlockedCount) / \(achievements.count)\nCompleted"
    }
}

extension AchievementsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as! AchievementCell
        cell.configure(with: achievements[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class AchievementCell: UITableViewCell {
    
    private let containerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let lockOverlay = UIView()
    private let lockIcon = UIImageView()
    
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
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        contentView.addSubview(containerView)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        containerView.addSubview(emojiLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        containerView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        descriptionLabel.numberOfLines = 2
        containerView.addSubview(descriptionLabel)
        
        lockOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        lockOverlay.layer.cornerRadius = 16
        containerView.addSubview(lockOverlay)
        
        lockIcon.image = UIImage(systemName: "lock.fill")
        lockIcon.tintColor = UIColor.white.withAlphaComponent(0.7)
        lockIcon.contentMode = .scaleAspectFit
        lockOverlay.addSubview(lockIcon)
        
        [containerView, emojiLabel, titleLabel, descriptionLabel, lockOverlay, lockIcon].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            lockOverlay.topAnchor.constraint(equalTo: containerView.topAnchor),
            lockOverlay.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lockOverlay.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lockOverlay.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            lockIcon.centerXAnchor.constraint(equalTo: lockOverlay.centerXAnchor),
            lockIcon.centerYAnchor.constraint(equalTo: lockOverlay.centerYAnchor),
            lockIcon.widthAnchor.constraint(equalToConstant: 30),
            lockIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with achievement: Achievement) {
        emojiLabel.text = achievement.emoji
        titleLabel.text = achievement.title
        descriptionLabel.text = achievement.description
        
        lockOverlay.isHidden = achievement.isUnlocked
        containerView.layer.borderColor = achievement.isUnlocked ? achievement.color.cgColor : UIColor.white.withAlphaComponent(0.1).cgColor
        
        if achievement.isUnlocked {
            containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3) {
                self.containerView.transform = .identity
            }
        }
    }
}

class CircularProgressView: UIView {
    
    var lineWidth: CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var trackColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progressColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var _progress: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        trackColor.setStroke()
        trackPath.lineWidth = lineWidth
        trackPath.stroke()
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + CGFloat(_progress) * 2 * CGFloat.pi, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = .round
        progressPath.stroke()
        
        let percentageText = "\(Int(_progress * 100))%"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        let textSize = percentageText.size(withAttributes: attributes)
        let textRect = CGRect(
            x: center.x - textSize.width / 2,
            y: center.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        percentageText.draw(in: textRect, withAttributes: attributes)
    }
    
    
    func setProgress(_ progress: Double, animated: Bool = false) {
        let clampedProgress = max(0, min(1, progress))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "progress")
            animation.fromValue = _progress
            animation.toValue = clampedProgress
            animation.duration = 0.5
            layer.add(animation, forKey: "progressAnimation")
        }
        
        _progress = clampedProgress
        setNeedsDisplay()
    }
}

