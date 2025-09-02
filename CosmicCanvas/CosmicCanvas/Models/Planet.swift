import UIKit

struct Planet {
    let id: String
    let name: String
    let emoji: String
    let sfSymbol: String
    let color: UIColor
    let size: CGFloat // относительный размер для UI
    let distanceFromSun: Double // в млн км
    let orbitalPeriod: Double // в земных днях
    let dayLength: Double // в земных часах
    let moons: Int
    let temperature: ClosedRange<Int> // в °C
    let description: String
    let facts: [String]
    let quizQuestions: [QuizQuestion]
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

extension Planet {
    static let allPlanets: [Planet] = [
        Planet(
            id: "sun",
            name: "Sun",
            emoji: "☀️",
            sfSymbol: "sun.max.fill",
            color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0),
            size: 20.0,
            distanceFromSun: 0,
            orbitalPeriod: 0,
            dayLength: 648,
            moons: 0,
            temperature: 5505 ... 5505,
            description: "The Sun is a star at the center of our Solar System. It's a nearly perfect ball of hot plasma that provides light and heat to all planets.",
            facts: [
                "The Sun contains 99.86% of the Solar System's mass",
                "1.3 million Earths could fit inside the Sun",
                "The Sun's core temperature is 15 million°C",
                "Light from the Sun takes 8 minutes to reach Earth",
                "The Sun is 4.6 billion years old",
                "Every second, the Sun converts 4 million tons of matter into energy"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What type of celestial body is the Sun?",
                    options: ["Planet", "Star", "Moon", "Asteroid"],
                    correctAnswer: 1,
                    explanation: "The Sun is a star - a massive ball of hot gas held together by gravity!"
                ),
                QuizQuestion(
                    question: "How long does sunlight take to reach Earth?",
                    options: ["8 seconds", "8 minutes", "8 hours", "8 days"],
                    correctAnswer: 1,
                    explanation: "Light travels at 300,000 km/s, so it takes about 8 minutes to cover the 150 million km to Earth!"
                )
            ]
        ),
        Planet(
            id: "mercury",
            name: "Mercury",
            emoji: "☿️",
            sfSymbol: "moon.fill",
            color: UIColor(red: 0.7, green: 0.6, blue: 0.5, alpha: 1.0),
            size: 0.38,
            distanceFromSun: 57.9,
            orbitalPeriod: 88,
            dayLength: 1408,
            moons: 0,
            temperature: -173 ... 427,
            description: "Mercury is the smallest planet in our Solar System and the closest to the Sun. Despite being closest to the Sun, it's not the hottest planet!",
            facts: [
                "A day on Mercury lasts 59 Earth days",
                "Mercury has no atmosphere to retain heat",
                "It's only slightly larger than Earth's Moon",
                "Mercury has water ice at its poles",
                "Mercury is shrinking - it has shrunk 7km in radius",
                "It has the most eccentric orbit of all planets",
                "Mercury can be seen with the naked eye from Earth"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "How many moons does Mercury have?",
                    options: ["0", "1", "2", "3"],
                    correctAnswer: 0,
                    explanation: "Mercury has no moons, just like Venus!"
                ),
                QuizQuestion(
                    question: "Is Mercury the hottest planet?",
                    options: ["Yes", "No"],
                    correctAnswer: 1,
                    explanation: "Despite being closest to the Sun, Venus is actually hotter due to its thick atmosphere!"
                )
            ]
        ),
        
        Planet(
            id: "venus",
            name: "Venus",
            emoji: "🌅",
            sfSymbol: "sun.max.fill",
            color: UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 1.0),
            size: 0.95,
            distanceFromSun: 108.2,
            orbitalPeriod: 225,
            dayLength: 5832,
            moons: 0,
            temperature: 462...462,
            description: "Venus is often called Earth's twin because of their similar size, but it's a hellish world with crushing pressure and acid rain!",
            facts: [
                "Venus rotates backwards compared to most planets",
                "A day on Venus is longer than its year",
                "It's the hottest planet in our Solar System",
                "Venus has thousands of volcanoes"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "Why is Venus the hottest planet?",
                    options: ["It's closest to the Sun", "Thick CO2 atmosphere", "Volcanic activity", "Solar flares"],
                    correctAnswer: 1,
                    explanation: "Venus's thick carbon dioxide atmosphere creates a runaway greenhouse effect!"
                )
            ]
        ),
        
        Planet(
            id: "earth",
            name: "Earth",
            emoji: "🌍",
            sfSymbol: "globe.americas.fill",
            color: UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0),
            size: 1.0,
            distanceFromSun: 149.6,
            orbitalPeriod: 365.25,
            dayLength: 24,
            moons: 1,
            temperature: -88...58,
            description: "Our home planet is the only known planet with life. It has liquid water, a breathable atmosphere, and a protective magnetic field.",
            facts: [
                "Earth is the only planet not named after a god",
                "70% of Earth's surface is covered by water",
                "Earth's core is as hot as the Sun's surface",
                "A day is getting longer by 1.7 milliseconds per century",
                "Earth's Moon is the 5th largest moon in the Solar System",
                "The Moon is moving away from Earth at 3.8 cm per year",
                "Earth is the densest planet in the Solar System"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What percentage of Earth is covered by water?",
                    options: ["50%", "60%", "70%", "80%"],
                    correctAnswer: 2,
                    explanation: "About 70% of Earth's surface is covered by oceans!"
                )
            ]
        ),
        
        Planet(
            id: "mars",
            name: "Mars",
            emoji: "🔴",
            sfSymbol: "flame.fill",
            color: UIColor(red: 0.8, green: 0.3, blue: 0.2, alpha: 1.0),
            size: 0.53,
            distanceFromSun: 227.9,
            orbitalPeriod: 687,
            dayLength: 24.6,
            moons: 2,
            temperature: -125...20,
            description: "The Red Planet gets its color from iron oxide (rust) on its surface. It's the most explored planet after Earth!",
            facts: [
                "Mars has the largest volcano in the Solar System - Olympus Mons (21km high)",
                "A day on Mars is 24 hours 37 minutes",
                "Mars has two tiny moons: Phobos and Deimos",
                "There's evidence of ancient rivers on Mars",
                "Phobos orbits so close it appears to rise in the west",
                "Mars had a thick atmosphere billions of years ago",
                "Water ice exists at both Martian poles"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What gives Mars its red color?",
                    options: ["Blood", "Iron oxide (rust)", "Red sand", "Reflection from the Sun"],
                    correctAnswer: 1,
                    explanation: "Iron oxide, commonly known as rust, gives Mars its distinctive red color!"
                )
            ]
        ),
        
        Planet(
            id: "jupiter",
            name: "Jupiter",
            emoji: "🟤",
            sfSymbol: "hurricane",
            color: UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0),
            size: 11.2,
            distanceFromSun: 778.5,
            orbitalPeriod: 4333,
            dayLength: 9.9,
            moons: 95,
            temperature: -108 ... -108,
            description: "Jupiter is the largest planet in our Solar System. Its Great Red Spot is a storm larger than Earth that's been raging for centuries!",
            facts: [
                "Jupiter has 95 known moons",
                "It acts as a 'vacuum cleaner' protecting Earth from asteroids",
                "Jupiter has the shortest day of all planets",
                "The Great Red Spot is shrinking",
                "Ganymede (moon) is larger than Mercury",
                "Io is the most volcanically active body in the Solar System",
                "Europa likely has an ocean under its icy surface",
                "Callisto has the most heavily cratered surface in the Solar System"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What is the Great Red Spot?",
                    options: ["A mountain", "A storm", "A lake", "A volcano"],
                    correctAnswer: 1,
                    explanation: "The Great Red Spot is a giant storm that's been raging for at least 350 years!"
                )
            ]
        ),
        
        Planet(
            id: "saturn",
            name: "Saturn",
            emoji: "🪐",
            sfSymbol: "record.circle.fill",
            color: UIColor(red: 0.9, green: 0.8, blue: 0.6, alpha: 1.0),
            size: 9.5,
            distanceFromSun: 1432,
            orbitalPeriod: 10747,
            dayLength: 10.7,
            moons: 146,
            temperature: -139 ... -139,
            description: "Saturn is famous for its spectacular ring system. It's the least dense planet - it would float in water!",
            facts: [
                "Saturn has 146 known moons",
                "Its rings are made of ice and rock",
                "Saturn is less dense than water",
                "A year on Saturn is 29 Earth years"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What are Saturn's rings made of?",
                    options: ["Gas", "Ice and rock", "Dust only", "Metal"],
                    correctAnswer: 1,
                    explanation: "Saturn's rings are made of billions of pieces of ice and rock!"
                )
            ]
        ),
        
        Planet(
            id: "uranus",
            name: "Uranus",
            emoji: "🔵",
            sfSymbol: "snowflake",
            color: UIColor(red: 0.4, green: 0.7, blue: 0.8, alpha: 1.0),
            size: 4.0,
            distanceFromSun: 2867,
            orbitalPeriod: 30589,
            dayLength: 17.2,
            moons: 28,
            temperature: -197 ... -197,
            description: "Uranus is tilted on its side, rolling around the Sun like a ball. It's the coldest planetary atmosphere in the Solar System!",
            facts: [
                "Uranus rotates on its side at 98 degrees",
                "It has faint rings like Saturn",
                "A season on Uranus lasts 21 years",
                "It's the coldest planet in our Solar System"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What's unique about Uranus's rotation?",
                    options: ["It doesn't rotate", "It rotates backwards", "It rotates on its side", "It rotates very fast"],
                    correctAnswer: 2,
                    explanation: "Uranus is tilted at 98 degrees, essentially rolling on its side as it orbits the Sun!"
                )
            ]
        ),
        
        Planet(
            id: "neptune",
            name: "Neptune",
            emoji: "🔵",
            sfSymbol: "wind",
            color: UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1.0),
            size: 3.9,
            distanceFromSun: 4515,
            orbitalPeriod: 59800,
            dayLength: 16.1,
            moons: 16,
            temperature: -201 ... -201,
            description: "Neptune is the windiest planet with speeds up to 2,100 km/h. It's a deep blue color due to methane in its atmosphere.",
            facts: [
                "Neptune has the fastest winds in the Solar System",
                "It takes 165 Earth years to orbit the Sun",
                "Neptune has 16 known moons",
                "It rains diamonds on Neptune"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What causes Neptune's blue color?",
                    options: ["Water", "Methane", "Nitrogen", "Oxygen"],
                    correctAnswer: 1,
                    explanation: "Methane in Neptune's atmosphere absorbs red light, making the planet appear blue!"
                )
            ]
        ),
        
        // Dwarf Planets
        Planet(
            id: "pluto",
            name: "Pluto",
            emoji: "🪨",
            sfSymbol: "globe",
            color: UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0),
            size: 0.18,
            distanceFromSun: 5906,
            orbitalPeriod: 90560,
            dayLength: 153,
            moons: 5,
            temperature: -223 ... -223,
            description: "Pluto was the 9th planet until 2006. Now classified as a dwarf planet, it has a heart-shaped glacier and five moons!",
            facts: [
                "Pluto was discovered in 1930 by Clyde Tombaugh",
                "It takes 248 Earth years to orbit the Sun",
                "Pluto has a heart-shaped nitrogen glacier",
                "Its largest moon Charon is half Pluto's size",
                "New Horizons flew by Pluto in 2015",
                "Pluto's atmosphere freezes and falls as snow",
                "It's smaller than Earth's Moon"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "Why is Pluto no longer a planet?",
                    options: ["Too small", "Too far", "Hasn't cleared its orbit", "Too cold"],
                    correctAnswer: 2,
                    explanation: "Pluto hasn't cleared its orbital neighborhood of other objects, which is required to be a planet!"
                )
            ]
        ),
        
        Planet(
            id: "ceres",
            name: "Ceres",
            emoji: "⚪",
            sfSymbol: "moon.circle.fill",
            color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
            size: 0.07,
            distanceFromSun: 413,
            orbitalPeriod: 1682,
            dayLength: 9,
            moons: 0,
            temperature: -105 ... -105,
            description: "Ceres is the largest object in the asteroid belt and the only dwarf planet in the inner Solar System. It might have an ocean!",
            facts: [
                "Ceres is the largest asteroid in the asteroid belt",
                "It contains 25% of the asteroid belt's total mass",
                "Ceres might have more water than Earth",
                "It has mysterious bright spots in craters",
                "Dawn spacecraft orbited Ceres from 2015-2018",
                "It's the smallest dwarf planet"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "Where is Ceres located?",
                    options: ["Beyond Neptune", "Asteroid belt", "Near Jupiter", "Kuiper belt"],
                    correctAnswer: 1,
                    explanation: "Ceres orbits in the asteroid belt between Mars and Jupiter!"
                )
            ]
        ),
        
        Planet(
            id: "eris",
            name: "Eris",
            emoji: "🌑",
            sfSymbol: "moon.stars.fill",
            color: UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0),
            size: 0.18,
            distanceFromSun: 10120,
            orbitalPeriod: 203830,
            dayLength: 25.9,
            moons: 1,
            temperature: -231 ... -231,
            description: "Eris is the most massive dwarf planet and caused Pluto's reclassification. It's so far away that the Sun looks like a bright star!",
            facts: [
                "Eris is more massive than Pluto",
                "Its discovery led to Pluto's demotion",
                "It takes 557 years to orbit the Sun",
                "Has one moon named Dysnomia",
                "It's the most distant dwarf planet",
                "Named after the Greek goddess of discord"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What caused Pluto to lose planet status?",
                    options: ["Getting smaller", "Discovery of Eris", "Moving away", "Losing moons"],
                    correctAnswer: 1,
                    explanation: "The discovery of Eris, which is more massive than Pluto, led to the new planet definition!"
                )
            ]
        ),
        
        Planet(
            id: "makemake",
            name: "Makemake",
            emoji: "🟤",
            sfSymbol: "sparkle.magnifyingglass",
            color: UIColor(red: 0.8, green: 0.6, blue: 0.5, alpha: 1.0),
            size: 0.11,
            distanceFromSun: 6850,
            orbitalPeriod: 112897,
            dayLength: 22.5,
            moons: 1,
            temperature: -239 ... -239,
            description: "Makemake is a reddish dwarf planet in the Kuiper Belt. It's named after the creation deity of the Rapa Nui people of Easter Island.",
            facts: [
                "Makemake is the third largest dwarf planet",
                "It's extremely cold and covered in methane ice",
                "Has one small moon discovered in 2016",
                "Takes 305 Earth years to orbit the Sun",
                "Named after Easter Island mythology",
                "It's one of the brightest Kuiper Belt objects"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What covers Makemake's surface?",
                    options: ["Water ice", "Methane ice", "Nitrogen ice", "Carbon dioxide"],
                    correctAnswer: 1,
                    explanation: "Makemake is covered in frozen methane, giving it a reddish color!"
                )
            ]
        ),
        
        // Asteroids
        Planet(
            id: "asteroid-belt",
            name: "Asteroid Belt",
            emoji: "🪨",
            sfSymbol: "hexagon",
            color: UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0),
            size: 0.5,
            distanceFromSun: 350,
            orbitalPeriod: 1650,
            dayLength: 0,
            moons: 0,
            temperature: -73 ... -73,
            description: "The Asteroid Belt contains millions of rocky objects between Mars and Jupiter. It's the remains of a planet that never formed!",
            facts: [
                "Contains over 1 million asteroids larger than 1 km",
                "Total mass is less than Earth's Moon",
                "Ceres makes up 25% of the belt's mass",
                "Formed from leftover planet-building material",
                "Most asteroids are irregularly shaped",
                "Dawn mission explored Vesta and Ceres"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "Where is the Asteroid Belt?",
                    options: ["Near Earth", "Between Mars and Jupiter", "Beyond Neptune", "Around Saturn"],
                    correctAnswer: 1,
                    explanation: "The Asteroid Belt orbits between Mars and Jupiter!"
                )
            ]
        ),
        
        Planet(
            id: "vesta",
            name: "Vesta",
            emoji: "🪨",
            sfSymbol: "diamond.fill",
            color: UIColor(red: 0.7, green: 0.6, blue: 0.5, alpha: 1.0),
            size: 0.04,
            distanceFromSun: 353,
            orbitalPeriod: 1325,
            dayLength: 5.3,
            moons: 0,
            temperature: -130 ... -60,
            description: "Vesta is the brightest asteroid and has a giant crater from an ancient collision. You can see it with the naked eye!",
            facts: [
                "Second most massive asteroid",
                "Has a giant crater 500 km wide",
                "Visible with naked eye from Earth",
                "Dawn spacecraft visited in 2011-2012",
                "Has volcanic rock on its surface",
                "Source of many meteorites found on Earth"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What makes Vesta special?",
                    options: ["Largest asteroid", "Has water", "Visible from Earth", "Has moons"],
                    correctAnswer: 2,
                    explanation: "Vesta is bright enough to be seen with the naked eye!"
                )
            ]
        ),
        
        // Comets
        Planet(
            id: "halley",
            name: "Halley's Comet",
            emoji: "☄️",
            sfSymbol: "sparkle",
            color: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),
            size: 0.01,
            distanceFromSun: 2800,
            orbitalPeriod: 27375,
            dayLength: 52.8,
            moons: 0,
            temperature: -230 ... -230,
            description: "The most famous comet! Returns every 75-76 years. Last seen in 1986, next appearance in 2061!",
            facts: [
                "Returns every 75-76 years",
                "Last visible in 1986, returns in 2061",
                "First recorded by Chinese in 240 BC",
                "About 15 km long and 8 km wide",
                "Loses material each time it approaches the Sun",
                "Named after Edmond Halley who predicted its return"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "When will Halley's Comet return?",
                    options: ["2035", "2050", "2061", "2075"],
                    correctAnswer: 2,
                    explanation: "Halley's Comet will next be visible in 2061!"
                )
            ]
        ),
        
        Planet(
            id: "hale-bopp",
            name: "Hale-Bopp",
            emoji: "☄️",
            sfSymbol: "star.fill",
            color: UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0),
            size: 0.06,
            distanceFromSun: 37000,
            orbitalPeriod: 2533000,
            dayLength: 0,
            moons: 0,
            temperature: -240 ... -240,
            description: "One of the brightest comets ever! Visible for 18 months in 1996-1997. Won't return for 2,500 years!",
            facts: [
                "Visible for record 18 months",
                "One of the brightest comets in history",
                "Won't return for 2,500 years",
                "Had two distinct tails",
                "Discovered by two amateur astronomers",
                "Nucleus is 40-80 km wide"
            ],
            quizQuestions: [
                QuizQuestion(
                    question: "What made Hale-Bopp famous?",
                    options: ["Hit Earth", "Visible for 18 months", "Largest comet", "Has rings"],
                    correctAnswer: 1,
                    explanation: "Hale-Bopp was visible to the naked eye for a record 18 months!"
                )
            ]
        )
    ]
}