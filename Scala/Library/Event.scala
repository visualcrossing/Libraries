import java.time.LocalDateTime

class Event(
             private var _datetime: Option[LocalDateTime] = None,
             private var _datetimeEpoch: Option[Long] = None,
             private var _type: Option[String] = None,
             private var _latitude: Option[Double] = None,
             private var _longitude: Option[Double] = None,
             private var _distance: Option[Double] = None,
             private var _description: Option[String] = None,
             private var _size: Option[Double] = None
           ) {

  def datetime: Option[LocalDateTime] = _datetime
  def datetime_=(datetime: Option[String]): Unit = {
    _datetime = datetime.map(LocalDateTime.parse)
  }

  def datetimeEpoch: Option[Long] = _datetimeEpoch
  def datetimeEpoch_=(datetimeEpoch: Option[Long]): Unit = {
    _datetimeEpoch = datetimeEpoch
  }

  def `type`: Option[String] = _type
  def type_=(t: Option[String]): Unit = {
    _type = t
  }

  def latitude: Option[Double] = _latitude
  def latitude_=(latitude: Option[Double]): Unit = {
    _latitude = latitude
  }

  def longitude: Option[Double] = _longitude
  def longitude_=(longitude: Option[Double]): Unit = {
    _longitude = longitude
  }

  def distance: Option[Double] = _distance
  def distance_=(distance: Option[Double]): Unit = {
    _distance = distance
  }

  def description: Option[String] = _description
  def description_=(description: Option[String]): Unit = {
    _description = description
  }

  def size: Option[Double] = _size
  def size_=(size: Option[Double]): Unit = {
    _size = size
  }
}
