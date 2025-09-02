import UIKit

enum SpaceObjectType {
    case star
    case planet
    case dwarfPlanet
    case asteroid
    case comet
}

struct SpaceObject {
    let id: String
    let name: String
    let type: SpaceObjectType
    let emoji: String
    let sfSymbol: String
    let color: UIColor
    let size: CGFloat
    let distanceFromSun: Double
    let orbitalPeriod: Double
    let description: String
    let facts: [String]
    let quizQuestions: [QuizQuestion]
    
    // Optional properties for different types
    let dayLength: Double?
    let moons: Int?
    let temperature: ClosedRange<Int>?
    let composition: String?
    let discoveryYear: Int?
}

extension SpaceObject {
    static let asteroids: [SpaceObject] = [
        SpaceObject(
            id: "asteroid-belt",
            name: "Asteroid Belt",
            type: .asteroid,
            emoji: "🪨",
            sfSymbol: "circle.hexagongrid",
            color: UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0),
            size: 0.5,
            distanceFromSun: 350,
            orbitalPeriod: 1650,
            description: "The Asteroid Belt is a region between Mars and Jupiter containing millions of rocky objects. It's like a cosmic junkyard!",
            facts: [
                "Contains millions of asteroids",
                "Total mass is less than Earth's Moon",
                "Ceres makes up 25% of the belt's mass",
                "Most asteroids are less than 1 km across",
                "The belt is mostly empty space",
                "Formed from a planet that never formed"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "Where is the Asteroid Belt located?",
                    options: ["Between Earth and Mars", "Between Mars and Jupiter", "Beyond Neptune", "Near the Sun"],
                    correctAnswer: 1,
                    explanation: "The Asteroid Belt orbits between Mars and Jupiter!"
                )
            ],
            dayLength: nil,
            moons: nil,
            temperature: nil,
            composition: "Rock and metal",
            discoveryYear: 1801
        ),
        
        SpaceObject(
            id: "vesta",
            name: "Vesta",
            type: .asteroid,
            emoji: "🪨",
            sfSymbol: "hexagon.fill",
            color: UIColor(red: 0.7, green: 0.6, blue: 0.5, alpha: 1.0),
            size: 0.04,
            distanceFromSun: 353,
            orbitalPeriod: 1325,
            description: "Vesta is the second-largest asteroid and the brightest. It has a huge crater from an ancient impact!",
            facts: [
                "Second most massive asteroid",
                "Has a giant crater 500 km wide",
                "You can see it with the naked eye",
                "Dawn spacecraft visited in 2011-2012",
                "Has basaltic lava on surface",
                "Source of many meteorites on Earth"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What makes Vesta special?",
                    options: ["Largest asteroid", "Has water", "Visible from Earth", "Has moons"],
                    correctAnswer: 2,
                    explanation: "Vesta is the brightest asteroid and can be seen with the naked eye!"
                )
            ],
            dayLength: 5.3,
            moons: 0,
            temperature: -60 ... -130,
            composition: "Basaltic rock",
            discoveryYear: 1807
        )
    ]
    
    static let comets: [SpaceObject] = [
        SpaceObject(
            id: "halley",
            name: "Halley's Comet",
            type: .comet,
            emoji: "☄️",
            sfSymbol: "sparkle",
            color: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),
            size: 0.01,
            distanceFromSun: 2800,
            orbitalPeriod: 27375,
            description: "The most famous comet! Halley's Comet visits Earth every 75-76 years. It last appeared in 1986 and will return in 2061!",
            facts: [
                "Returns every 75-76 years",
                "Last seen in 1986, returns in 2061",
                "Recorded by Chinese astronomers in 240 BC",
                "About 15 km long and 8 km wide",
                "Loses 6 meters of ice each orbit",
                "Named after Edmond Halley who calculated its orbit"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "When will Halley's Comet return?",
                    options: ["2035", "2050", "2061", "2075"],
                    correctAnswer: 2,
                    explanation: "Halley's Comet will next be visible from Earth in 2061!"
                )
            ],
            dayLength: 52.8,
            moons: nil,
            temperature: nil,
            composition: "Ice and dust",
            discoveryYear: 1705
        ),
        
        SpaceObject(
            id: "hale-bopp",
            name: "Hale-Bopp",
            type: .comet,
            emoji: "☄️",
            sfSymbol: "star.fill",
            color: UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0),
            size: 0.06,
            distanceFromSun: 37000,
            orbitalPeriod: 2533000,
            description: "One of the brightest comets of the 20th century! It was visible to the naked eye for 18 months in 1996-1997.",
            facts: [
                "Visible for 18 months in 1996-1997",
                "One of the brightest comets ever",
                "Won't return for 2,500 years",
                "Has two distinct tails",
                "Discovered by two amateur astronomers",
                "Nucleus is 40-80 km wide"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What made Hale-Bopp special?",
                    options: ["Closest to Earth", "Visible for 18 months", "Hit Jupiter", "Has rings"],
                    correctAnswer: 1,
                    explanation: "Hale-Bopp was visible to the naked eye for a record 18 months!"
                )
            ],
            dayLength: nil,
            moons: nil,
            temperature: nil,
            composition: "Ice, dust, and gas",
            discoveryYear: 1995
        )
    ]
}