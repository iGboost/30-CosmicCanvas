import UIKit

struct QuizCategory {
    let id: String
    let title: String
    let emoji: String
    let description: String
    let color: UIColor
    let objects: [Planet]
    
    var questions: [QuizQuestion] {
        return objects.flatMap { $0.quizQuestions }
    }
}

class QuizCategoryViewController: UIViewController {
    
    private let starfield = StarfieldView()
    private let collectionView: UICollectionView
    private var categories: [QuizCategory] = []
    
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
        loadCategories()
    }
    
    private func setupUI() {
        title = "Choose Category"
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuizCategoryCell.self, forCellWithReuseIdentifier: "QuizCategoryCell")
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        [starfield, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadCategories() {
        let planets = Planet.allPlanets.filter { !["pluto", "ceres", "eris", "makemake", "asteroid-belt", "vesta", "halley", "hale-bopp"].contains($0.id) && $0.id != "sun" }
        let dwarfPlanets = Planet.allPlanets.filter { ["pluto", "ceres", "eris", "makemake"].contains($0.id) }
        let asteroids = Planet.allPlanets.filter { ["asteroid-belt", "vesta"].contains($0.id) }
        let comets = Planet.allPlanets.filter { ["halley", "hale-bopp"].contains($0.id) }
        let star = Planet.allPlanets.filter { $0.id == "sun" }
        
        categories = [
            QuizCategory(
                id: "planets",
                title: "Planets",
                emoji: "🪐",
                description: "Test your knowledge about the 8 planets",
                color: UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0),
                objects: planets
            ),
            QuizCategory(
                id: "star",
                title: "Our Star",
                emoji: "☀️",
                description: "Learn about the Sun",
                color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0),
                objects: star
            ),
            QuizCategory(
                id: "dwarf",
                title: "Dwarf Planets",
                emoji: "🌑",
                description: "Explore dwarf planets like Pluto",
                color: UIColor(red: 0.7, green: 0.5, blue: 0.8, alpha: 1.0),
                objects: dwarfPlanets
            ),
            QuizCategory(
                id: "asteroids",
                title: "Asteroids",
                emoji: "🪨",
                description: "Rocky objects in space",
                color: UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0),
                objects: asteroids
            ),
            QuizCategory(
                id: "comets",
                title: "Comets",
                emoji: "☄️",
                description: "Icy visitors from deep space",
                color: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),
                objects: comets
            ),
            QuizCategory(
                id: "all",
                title: "Mixed Quiz",
                emoji: "🌌",
                description: "Questions about everything",
                color: UIColor(red: 0.9, green: 0.8, blue: 0.2, alpha: 1.0),
                objects: Planet.allPlanets
            )
        ]
    }
}

extension QuizCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCategoryCell", for: indexPath) as! QuizCategoryCell
        cell.configure(with: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 56) / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let category = categories[indexPath.item]
        let quizVC = QuizViewController(category: category)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

class QuizCategoryCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let questionCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        contentView.addSubview(containerView)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 40)
        emojiLabel.textAlignment = .center
        containerView.addSubview(emojiLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        
        questionCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        questionCountLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        questionCountLabel.textAlignment = .center
        containerView.addSubview(questionCountLabel)
        
        [containerView, emojiLabel, titleLabel, descriptionLabel, questionCountLabel].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            questionCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            questionCountLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            questionCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with category: QuizCategory) {
        emojiLabel.text = category.emoji
        titleLabel.text = category.title
        descriptionLabel.text = category.description
        questionCountLabel.text = "\(category.questions.count) questions"
        containerView.layer.borderColor = category.color.cgColor
    }
}