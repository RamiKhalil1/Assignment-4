import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select Mood" }
    static var description: IntentDescription { "Choose your mood to generate an inspirational quote." }

    @Parameter(title: "Mood", default: .happiness)
    var mood: MoodCategory
}

enum MoodCategory: String, AppEnum {
    case age, alone, amazing, anger, architecture, art, attitude
    case beauty, best, birthday, business, car, change, communication
    case computers, cool, courage, dad, dating, death, design
    case dreams, education, environmental, equality, experience
    case failure, faith, family, famous, fear, fitness, food
    case forgiveness, freedom, friendship, funny, future, god, good
    case government, graduation, great, happiness, health, history
    case home, hope, humor, imagination, inspirational, intelligence
    case jealousy, knowledge, leadership, learning, legal, life
    case love, marriage, medical, men, mom, money, morning
    case movies, success

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Mood"
    }

    static var caseDisplayRepresentations: [MoodCategory: DisplayRepresentation] {
        [
            .age: "age",
            .alone: "alone",
            .amazing: "amazing",
            .anger: "anger",
            .architecture: "architecture",
            .art: "art",
            .attitude: "attitude",
            .beauty: "beauty",
            .best: "best",
            .birthday: "birthday",
            .business: "business",
            .car: "car",
            .change: "change",
            .communication: "communication",
            .computers: "computers",
            .cool: "cool",
            .courage: "courage",
            .dad: "dad",
            .dating: "dating",
            .death: "death",
            .design: "design",
            .dreams: "dreams",
            .education: "education",
            .environmental: "environmental",
            .equality: "equality",
            .experience: "experience",
            .failure: "failure",
            .faith: "faith",
            .family: "family",
            .famous: "famous",
            .fear: "fear",
            .fitness: "fitness",
            .food: "food",
            .forgiveness: "forgiveness",
            .freedom: "freedom",
            .friendship: "friendship",
            .funny: "funny",
            .future: "future",
            .god: "god",
            .good: "good",
            .government: "government",
            .graduation: "graduation",
            .great: "great",
            .happiness: "happiness",
            .health: "health",
            .history: "history",
            .home: "home",
            .hope: "hope",
            .humor: "humor",
            .imagination: "imagination",
            .inspirational: "inspirational",
            .intelligence: "intelligence",
            .jealousy: "jealousy",
            .knowledge: "knowledge",
            .leadership: "leadership",
            .learning: "learning",
            .legal: "legal",
            .life: "life",
            .love: "love",
            .marriage: "marriage",
            .medical: "medical",
            .men: "men",
            .mom: "mom",
            .money: "money",
            .morning: "morning",
            .movies: "movies",
            .success: "success"
        ]
    }
}
