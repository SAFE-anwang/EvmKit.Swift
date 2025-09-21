import UIKit
import ObjectMapper

public enum FlexibleValue: RawRepresentable {
    case int(Int)
    case string(String)
    case double(Double)
    case bool(Bool)
    case null
    
    public typealias RawValue = Any
    
    public init?(rawValue: Any) {
        if let intValue = rawValue as? Int {
            self = .int(intValue)
        } else if let stringValue = rawValue as? String {
            self = .string(stringValue)
        } else if let doubleValue = rawValue as? Double {
            self = .double(doubleValue)
        } else if let boolValue = rawValue as? Bool {
            self = .bool(boolValue)
        } else if rawValue is NSNull {
            self = .null
        } else {
            return nil
        }
    }
    
    public var rawValue: Any {
        switch self {
        case .int(let value): return value
        case .string(let value): return value
        case .double(let value): return value
        case .bool(let value): return value
        case .null: return NSNull()
        }
    }
    
    public var intValue: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }
    
    public var stringValue: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    public var doubleValue: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }
    
    public var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    public var description: String {
        switch self {
        case .int(let value): return "\(value)"
        case .string(let value): return value
        case .double(let value): return "\(value)"
        case .bool(let value): return "\(value)"
        case .null: return "null"
        }
    }
}



