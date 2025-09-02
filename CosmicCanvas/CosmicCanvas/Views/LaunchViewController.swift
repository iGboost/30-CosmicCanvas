import UIKit

class LaunchViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let starfield = StarfieldView()
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.05, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.05, green: 0.02, blue: 0.15, alpha: 1.0).cgColor,
            UIColor(red: 0.02, green: 0.01, blue: 0.08, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(starfield)
        
        logoImageView.image = UIImage(systemName: "sparkles")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        view.addSubview(logoImageView)
        
        titleLabel.text = "CosmicCanvas"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.alpha = 0
        view.addSubview(titleLabel)
        
        subtitleLabel.text = "Generate cosmic wallpapers"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel.textAlignment = .center
        subtitleLabel.alpha = 0
        view.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        [starfield, logoImageView, titleLabel, subtitleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func startAnimations() {
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 1.0, delay: 1.0) {
            self.titleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 1.0, delay: 1.3) {
            self.subtitleLabel.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.transitionToOnboarding()
        }
    }
    
    private func transitionToOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.modalTransitionStyle = .crossDissolve
        present(onboardingVC, animated: true)
    }
}

class StarfieldView: UIView {
    
    private var stars: [CALayer] = []
    private var displayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStarfield()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStarfield()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createStars()
    }
    
    private func setupStarfield() {
        backgroundColor = .clear
        displayLink = CADisplayLink(target: self, selector: #selector(updateStars))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    private func createStars() {
        stars.forEach { $0.removeFromSuperlayer() }
        stars.removeAll()
        
        for _ in 0..<100 {
            let star = CALayer()
            star.backgroundColor = UIColor.white.cgColor
            star.opacity = Float.random(in: 0.3...1.0)
            
            let size = CGFloat.random(in: 1...3)
            star.frame = CGRect(x: CGFloat.random(in: 0...bounds.width),
                               y: CGFloat.random(in: 0...bounds.height),
                               width: size, height: size)
            star.cornerRadius = size / 2
            
            layer.addSublayer(star)
            stars.append(star)
            
            let twinkleAnimation = CABasicAnimation(keyPath: "opacity")
            twinkleAnimation.fromValue = star.opacity
            twinkleAnimation.toValue = star.opacity * 0.3
            twinkleAnimation.duration = Double.random(in: 1.0...3.0)
            twinkleAnimation.autoreverses = true
            twinkleAnimation.repeatCount = .infinity
            star.add(twinkleAnimation, forKey: "twinkle")
        }
    }
    
    @objc private func updateStars() {
        for star in stars {
            var frame = star.frame
            frame.origin.y += 0.5
            
            if frame.origin.y > bounds.height {
                frame.origin.y = -frame.height
                frame.origin.x = CGFloat.random(in: 0...bounds.width)
            }
            
            star.frame = frame
        }
    }
    
    deinit {
        displayLink?.invalidate()
    }
}