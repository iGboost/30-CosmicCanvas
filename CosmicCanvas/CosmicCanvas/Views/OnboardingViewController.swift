import UIKit

class OnboardingViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let continueButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)
    private let starfield = StarfieldView()
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "globe.europe.africa.fill",
            title: "Explore Planets",
            description: "Learn about all planets in our Solar System with interactive guides",
            color: UIColor(red: 0.3, green: 0.2, blue: 0.8, alpha: 1.0)
        ),
        OnboardingPage(
            icon: "brain.fill",
            title: "Test Your Knowledge",
            description: "Take fun quizzes about planets and space facts",
            color: UIColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1.0)
        ),
        OnboardingPage(
            icon: "star.circle.fill",
            title: "Earn Achievements",
            description: "Collect badges and track your learning progress",
            color: UIColor(red: 0.2, green: 0.7, blue: 0.6, alpha: 1.0)
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(pages.count), height: scrollView.bounds.height)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl)
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = UIColor(red: 0.3, green: 0.2, blue: 0.8, alpha: 1.0)
        continueButton.layer.cornerRadius = 25
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(continueButton)
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        skipButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        view.addSubview(skipButton)
    }
    
    private func setupConstraints() {
        [starfield, scrollView, pageControl, continueButton, skipButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -30),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -15),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupPages() {
        for (index, page) in pages.enumerated() {
            let pageView = createPageView(for: page, at: index)
            scrollView.addSubview(pageView)
            
            pageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                pageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                pageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * view.bounds.width),
                pageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                pageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
    }
    
    private func createPageView(for page: OnboardingPage, at index: Int) -> UIView {
        let containerView = UIView()
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: page.icon)
        iconView.tintColor = page.color
        iconView.contentMode = .scaleAspectFit
        containerView.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = page.title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = page.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        
        [iconView, titleLabel, descriptionLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -80),
            iconView.widthAnchor.constraint(equalToConstant: 120),
            iconView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40)
        ])
        
        return containerView
    }
    
    @objc private func continueButtonTapped() {
        let currentPage = pageControl.currentPage
        if currentPage < pages.count - 1 {
            let nextPage = currentPage + 1
            let offset = CGPoint(x: CGFloat(nextPage) * scrollView.bounds.width, y: 0)
            scrollView.setContentOffset(offset, animated: true)
            pageControl.currentPage = nextPage
            
            if nextPage == pages.count - 1 {
                continueButton.setTitle("Get Started", for: .normal)
            }
        } else {
            completeOnboarding()
        }
    }
    
    @objc private func skipButtonTapped() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        present(mainTabBarController, animated: true)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
        
        if page == pages.count - 1 {
            continueButton.setTitle("Get Started", for: .normal)
        } else {
            continueButton.setTitle("Continue", for: .normal)
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: UIColor
}