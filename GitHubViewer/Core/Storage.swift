import Foundation

enum Storage {
    enum Key {
        case isOnboardingComplete
        
        var value: String {
            switch self {
            case .isOnboardingComplete: return "isOnboardingComplete"
            }
        }
    }
    
    private static let defaults = UserDefaults.standard
    
    static func clearValue(for key: Key) {
        defaults.set(nil, forKey: key.value)
    }
    
    static func hasValue(for key: Key) -> Bool {
        return defaults.value(forKey: key.value) != nil
    }
    
    static func getValue<T>(for key: Key) -> T? {
        return defaults.value(forKey: key.value) as? T
    }
    
    static func set<T>(value: T, for key: Key) {
        defaults.set(value, forKey: key.value)
        defaults.synchronize()
    }
    
    static func reset() {
        clearValue(for: .isOnboardingComplete)
    }
}
