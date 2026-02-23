import Foundation
import SwiftData

@Model
final class BodyMeasurement {
    var id: UUID
    var date: Date
    var weightKg: Double?
    var bodyFatPercentage: Double?
    var chestCm: Double?
    var waistCm: Double?
    var hipsCm: Double?
    var leftBicepCm: Double?
    var rightBicepCm: Double?
    var leftThighCm: Double?
    var rightThighCm: Double?
    var neckCm: Double?
    var notes: String
    var photoAssetIdentifier: String?  // Photos library asset ID

    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.notes = ""
    }

    var leanMassKg: Double? {
        guard let weight = weightKg, let bf = bodyFatPercentage else { return nil }
        return weight * (1 - bf / 100)
    }

    var fatMassKg: Double? {
        guard let weight = weightKg, let bf = bodyFatPercentage else { return nil }
        return weight * (bf / 100)
    }

    // Waist-to-height ratio (health indicator)
    var waistToHeightRatio: Double? {
        guard let waist = waistCm else { return nil }
        return waist // caller should divide by height
    }
}
