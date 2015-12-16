import Foundation

struct JSONLite {
    static let NIL = JSONLite(nil)

    let rawValue: AnyObject?
    private var _dict: [String: AnyObject]? = nil
    private var _array: [AnyObject]? = nil

    init(_ other: JSONLite) {
        self.rawValue = other.rawValue
        _dict = other._dict
        _array = other._array
    }

    init(_ rawValue: AnyObject?) {
        self.rawValue = rawValue
        if let dict = rawValue as? [String: AnyObject] {
            _dict = dict
        } else if let arr = rawValue as? [AnyObject] {
            _array = arr
        }
    }

    var int: Int? {
        get {
            return rawValue as? Int
        }
    }

    var intValue: Int {
        get {
            return rawValue as? Int ?? 0
        }
    }

    var double: Double? {
        get {
            return rawValue as? Double
        }
    }

    var doubleValue: Double {
        get {
            return rawValue as? Double ?? 0.0
        }
    }

    var string: String? {
        get {
            return rawValue as? String
        }
    }

    var stringValue: String {
        get {
            return rawValue as? String ?? ""
        }
    }

    var bool: Bool? {
        get {
            return rawValue as? Bool
        }
    }

    var boolValue: Bool {
        get {
            return rawValue as? Bool ?? false
        }
    }

    var array: [AnyObject]? {
        get {
            return _array
        }
    }

    var arrayValue: [AnyObject] {
        get {
            return _array ?? []
        }
    }

    var dict: [String:AnyObject]? {
        get {
            return _dict
        }
    }

    var dictValue: [String:AnyObject] {
        get {
            return _dict ?? [:]
        }
    }

    subscript (index: Int) -> JSONLite {
        if let arr = _array where index >= 0 && index < arr.count {
            return JSONLite(arr[index])
        }
        return JSONLite.NIL
    }

    subscript (index: Int) -> String {
        if let arr = _array where index >= 0 && index < arr.count {
            return arr[index] as? String ?? ""
        }
        return ""
    }

    subscript (index: Int) -> Int {
        if let arr = _array where index >= 0 && index < arr.count {
            return arr[index] as? Int ?? 0
        }
        return 0
    }

    subscript (index: Int) -> Double {
        if let arr = _array where index >= 0 && index < arr.count {
            return arr[index] as? Double ?? 0.0
        }
        return 0.0
    }

    subscript (key: String) -> JSONLite {
        return JSONLite(_dict?[key])
    }

    subscript (key: String) -> String {
        return _dict?[key] as? String ?? ""
    }

    subscript (key: String) -> Int {
        return _dict?[key] as? Int ?? 0
    }

    subscript (key: String) -> Double {
        return _dict?[key] as? Double ?? 0.0
    }
}
