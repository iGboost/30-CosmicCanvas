import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        customizeAppearance()
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = true
        tabBar.barTintColor = UIColor(red: 0.05, green: 0.03, blue: 0.15, alpha: 0.95)
        tabBar.tintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
    }
    
    private func setupViewControllers() {
        let planets = PlanetsViewController()
        let planetsNav = UINavigationController(rootViewController: planets)
        planetsNav.tabBarItem = UITabBarItem(
            title: "Planets",
            image: UIImage(systemName: "globe"),
            selectedImage: UIImage(systemName: "globe.fill")
        )
        
        let quiz = QuizViewController()
        let quizNav = UINavigationController(rootViewController: quiz)
        quizNav.tabBarItem = UITabBarItem(
            title: "Quiz",
            image: UIImage(systemName: "brain"),
            selectedImage: UIImage(systemName: "brain.fill")
        )
        
        let achievements = AchievementsViewController()
        let achievementsNav = UINavigationController(rootViewController: achievements)
        achievementsNav.tabBarItem = UITabBarItem(
            title: "Progress",
            image: UIImage(systemName: "star.circle"),
            selectedImage: UIImage(systemName: "star.circle.fill")
        )
        
        viewControllers = [planetsNav, quizNav, achievementsNav]
        
        [planetsNav, quizNav, achievementsNav].forEach { nav in
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationBar.barTintColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
            nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.tintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        }
    }
    
    private func customizeAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 0.05, green: 0.03, blue: 0.15, alpha: 0.95)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}