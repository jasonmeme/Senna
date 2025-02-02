import Foundation

protocol ExerciseData {
    var name: String { get }
    var category: ExerciseCategory { get }
    var muscles: [String] { get }
    var equipment: String { get }
    var sets: [SetData] { get }
    var restSeconds: Int { get }
    var notes: String? { get }
} 