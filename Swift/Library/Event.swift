import Foundation

class Event {
    private var _datetime: Date?
    private var _datetimeEpoch: Int64?
    private var _type: String?
    private var _latitude: Double?
    private var _longitude: Double?
    private var _distance: Double?
    private var _description: String?
    private var _size: Double?

    // Constructor
    init() {}

    init(_Datetime: Date?, _DatetimeEpoch: Int64?, _Type: String?, _Latitude: Double?, _Longitude: Double?, _Distance: Double?, _Description: String?, _Size: Double?) {
        self._datetime = _Datetime
        self._datetimeEpoch = _DatetimeEpoch
        self._type = _Type
        self._latitude = _Latitude
        self._longitude = _Longitude
        self._distance = _Distance
        self._description = _Description
        self._size = _Size
    }

    // Properties with explicit getters and setters
    var _Datetime: Date? {
        get { return _datetime }
        set { _datetime = newValue }
    }

    var _DatetimeEpoch: Int64? {
        get { return _datetimeEpoch }
        set { _datetimeEpoch = newValue }
    }

    var _Type: String? {
        get { return _type }
        set { _type = newValue }
    }

    var _Latitude: Double? {
        get { return _latitude }
        set { _latitude = newValue }
    }

    var _Longitude: Double? {
        get { return _longitude }
        set { _longitude = newValue }
    }

    var _Distance: Double? {
        get { return _distance }
        set { _distance = newValue }
    }

    var _Description: String? {
        get { return _description }
        set { _description = newValue }
    }

    var _Size: Double? {
        get { return _size }
        set { _size = newValue }
    }
}
