import Foundation

class Station {
    private var _distance: Double?
    private var _latitude: Double?
    private var _longitude: Double?
    private var _useCount: Int64?
    private var _id: String?
    private var _name: String?
    private var _quality: Int64?
    private var _contribution: Double?

    // Constructor
    init() { }

    init(_Distance: Double?, _Latitude: Double?, _Longitude: Double?, _UseCount: Int64?, _Id: String?, _Name: String?, _Quality: Int64?, _Contribution: Double?) {
       self._distance = _Distance
       self._latitude = _Latitude
       self._longitude = _Longitude
       self._useCount = _UseCount
       self._id = _Id
       self._name = _Name
       self._quality = _Quality
       self._contribution = _Contribution
   }
    
    // Properties for each field
    var _Distance: Double? {
        get { return _distance }
        set { _distance = newValue }
    }

    var _Latitude: Double? {
        get { return _latitude }
        set { _latitude = newValue }
    }

    var _Longitude: Double? {
        get { return _longitude }
        set { _longitude = newValue }
    }

    var _UseCount: Int64? {
        get { return _useCount }
        set { _useCount = newValue }
    }

    var _Id: String? {
        get { return _id }
        set { _id = newValue }
    }

    var _Name: String? {
        get { return _name }
        set { _name = newValue }
    }

    var _Quality: Int64? {
        get { return _quality }
        set { _quality = newValue }
    }

    var _Contribution: Double? {
        get { return _contribution }
        set { _contribution = newValue }
    }
}
