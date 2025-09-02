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

class QuizViewController: UIViewController {
    
    private let starfield = StarfieldView()
    private let categoryCollectionView: UICollectionView
    private let questionCard = UIView()
    private let questionLabel = UILabel()
    private let progressView = UIProgressView()
    private let scoreLabel = UILabel()
    private let optionsStackView = UIStackView()
    private let explanationView = UIView()
    private let explanationLabel = UILabel()
    private let nextButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    private var categories: [QuizCategory] = []
    private var selectedCategory: QuizCategory?
    private var allQuestions: [QuizQuestion] = []
    private var currentQuestionIndex = 0
    private var score = 0
    private var hasAnswered = false
    private var isShowingCategories = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
        loadCategories()
        showCategories()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        
        view.addSubview(starfield)
        
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(QuizCategoryCell.self, forCellWithReuseIdentifier: "QuizCategoryCell")
        view.addSubview(categoryCollectionView)
        
        backButton.setTitle("←", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(backToCategories), for: .touchUpInside)
        backButton.isHidden = true
        view.addSubview(backButton)
        
        progressView.progressTintColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.2)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.isHidden = true
        view.addSubview(progressView)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .right
        scoreLabel.isHidden = true
        view.addSubview(scoreLabel)
        
        questionCard.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        questionCard.layer.cornerRadius = 20
        questionCard.layer.borderWidth = 1
        questionCard.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        questionCard.isHidden = true
        view.addSubview(questionCard)
        
        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionCard.addSubview(questionLabel)
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.distribution = .fillEqually
        optionsStackView.isHidden = true
        view.addSubview(optionsStackView)
        
        explanationView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.2)
        explanationView.layer.cornerRadius = 16
        explanationView.layer.borderWidth = 1
        explanationView.layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.5).cgColor
        explanationView.isHidden = true
        view.addSubview(explanationView)
        
        explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        explanationLabel.textColor = .white
        explanationLabel.textAlignment = .center
        explanationLabel.numberOfLines = 0
        explanationView.addSubview(explanationLabel)
        
        nextButton.setTitle("Next Question", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        nextButton.layer.cornerRadius = 25
        nextButton.isHidden = true
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        [starfield, categoryCollectionView, backButton, progressView, scoreLabel, questionCard, questionLabel, optionsStackView, explanationView, explanationLabel, nextButton].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            scoreLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100),
            
            questionCard.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            questionCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            questionLabel.topAnchor.constraint(equalTo: questionCard.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: -20),
            
            optionsStackView.topAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: 20),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            explanationView.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 20),
            explanationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            explanationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            explanationLabel.topAnchor.constraint(equalTo: explanationView.topAnchor, constant: 16),
            explanationLabel.leadingAnchor.constraint(equalTo: explanationView.leadingAnchor, constant: 16),
            explanationLabel.trailingAnchor.constraint(equalTo: explanationView.trailingAnchor, constant: -16),
            explanationLabel.bottomAnchor.constraint(equalTo: explanationView.bottomAnchor, constant: -16),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    
    private func startQuiz(category: QuizCategory) {
        selectedCategory = category
        allQuestions = category.questions.shuffled()
        currentQuestionIndex = 0
        score = 0
        isShowingCategories = false
        
        categoryCollectionView.isHidden = true
        questionCard.isHidden = false
        optionsStackView.isHidden = false
        backButton.isHidden = false
        progressView.isHidden = false
        scoreLabel.isHidden = false
        scoreLabel.text = "Score: 0"
        
        showQuestion()
    }
    
    @objc private func backToCategories() {
        showCategories()
    }
    
    func showCategories() {
        isShowingCategories = true
        categoryCollectionView.isHidden = false
        questionCard.isHidden = true
        optionsStackView.isHidden = true
        explanationView.isHidden = true
        nextButton.isHidden = true
        backButton.isHidden = true
        progressView.isHidden = true
        scoreLabel.isHidden = true
        
        // Reset quiz state
        currentQuestionIndex = 0
        score = 0
        hasAnswered = false
        allQuestions = []
        selectedCategory = nil
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        categoryCollectionView.reloadData()
    }
    
    private func showQuestion() {
        guard currentQuestionIndex < allQuestions.count else {
            showResults()
            return
        }
        
        hasAnswered = false
        explanationView.isHidden = true
        nextButton.isHidden = true
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let question = allQuestions[currentQuestionIndex]
        questionLabel.text = question.question
        
        progressView.progress = Float(currentQuestionIndex + 1) / Float(allQuestions.count)
        
        questionCard.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        questionCard.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.questionCard.transform = .identity
            self.questionCard.alpha = 1
        }
        
        for (index, option) in question.options.enumerated() {
            let button = createOptionButton(text: option, tag: index)
            optionsStackView.addArrangedSubview(button)
            
            button.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.3, delay: Double(index) * 0.1) {
                button.transform = .identity
            }
        }
    }
    
    private func createOptionButton(text: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.tag = tag
        button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        guard !hasAnswered else { return }
        hasAnswered = true
        
        let question = allQuestions[currentQuestionIndex]
        let isCorrect = sender.tag == question.correctAnswer
        
        if isCorrect {
            score += 10
            scoreLabel.text = "Score: \(score)"
            sender.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.3)
            sender.layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            sender.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.3)
            sender.layer.borderColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
            
            if let correctButton = optionsStackView.arrangedSubviews[question.correctAnswer] as? UIButton {
                correctButton.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.3)
                correctButton.layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
            }
        }
        
        explanationLabel.text = question.explanation
        explanationView.isHidden = false
        explanationView.alpha = 0
        explanationView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3) {
            self.explanationView.alpha = 1
            self.explanationView.transform = .identity
        }
        
        nextButton.isHidden = false
        nextButton.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.nextButton.alpha = 1
        }
        
        optionsStackView.isUserInteractionEnabled = false
    }
    
    @objc private func nextQuestion() {
        currentQuestionIndex += 1
        optionsStackView.isUserInteractionEnabled = true
        showQuestion()
    }
    
    private func showResults() {
        let resultsVC = QuizResultsViewController(score: score, totalQuestions: allQuestions.count, category: selectedCategory?.title ?? "Quiz")
        resultsVC.modalPresentationStyle = .fullScreen
        resultsVC.modalTransitionStyle = .crossDissolve
        present(resultsVC, animated: true)
    }
}

extension QuizViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        startQuiz(category: category)
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

class QuizResultsViewController: UIViewController {
    
    private let score: Int
    private let totalQuestions: Int
    private let category: String
    private let starfield = StarfieldView()
    
    init(score: Int, totalQuestions: Int, category: String) {
        self.score = score
        self.totalQuestions = totalQuestions
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.2, alpha: 1.0)
        view.addSubview(starfield)
        
        let percentage = Int((Double(score) / Double(totalQuestions * 10)) * 100)
        
        let trophyEmoji = UILabel()
        trophyEmoji.text = percentage >= 80 ? "🏆" : percentage >= 60 ? "🥈" : "🥉"
        trophyEmoji.font = UIFont.systemFont(ofSize: 100)
        trophyEmoji.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = "\(category) Complete!"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        let scoreLabel = UILabel()
        scoreLabel.text = "Score: \(score) / \(totalQuestions * 10)"
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        scoreLabel.textColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        scoreLabel.textAlignment = .center
        
        let percentageLabel = UILabel()
        percentageLabel.text = "\(percentage)%"
        percentageLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        if percentage >= 80 {
            messageLabel.text = "Amazing! You're a space expert!"
        } else if percentage >= 60 {
            messageLabel.text = "Great job! Keep learning!"
        } else {
            messageLabel.text = "Good try! Practice makes perfect!"
        }
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        messageLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        let playAgainButton = UIButton(type: .system)
        playAgainButton.setTitle("Try Again", for: .normal)
        playAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0)
        playAgainButton.layer.cornerRadius = 25
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        
        let homeButton = UIButton(type: .system)
        homeButton.setTitle("Choose Category", for: .normal)
        homeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        
        [starfield, trophyEmoji, titleLabel, scoreLabel, percentageLabel, messageLabel, playAgainButton, homeButton].forEach { 
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false 
        }
        
        NSLayoutConstraint.activate([
            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trophyEmoji.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trophyEmoji.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: trophyEmoji.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            percentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            percentageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playAgainButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -15),
            playAgainButton.widthAnchor.constraint(equalToConstant: 200),
            playAgainButton.heightAnchor.constraint(equalToConstant: 50),
            
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    @objc private func playAgain() {
        dismiss(animated: true)
    }
    
    @objc private func goHome() {
        dismiss(animated: true) {
            if let presentingVC = self.presentingViewController as? QuizViewController {
                presentingVC.showCategories()
            }
        }
    }
}