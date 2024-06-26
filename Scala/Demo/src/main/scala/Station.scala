class Station(
               private var _distance: Option[Double] = None,
               private var _latitude: Option[Double] = None,
               private var _longitude: Option[Double] = None,
               private var _useCount: Option[Int] = None,
               private var _id: Option[String] = None,
               private var _name: Option[String] = None,
               private var _quality: Option[Int] = None,
               private var _contribution: Option[Double] = None
             ) {

  def this() = this(None, None, None, None, None, None, None, None)

  def distance: Option[Double] = _distance
  def distance_=(distance: Option[Double]): Unit = {
    _distance = distance
  }

  def latitude: Option[Double] = _latitude
  def latitude_=(latitude: Option[Double]): Unit = {
    _latitude = latitude
  }

  def longitude: Option[Double] = _longitude
  def longitude_=(longitude: Option[Double]): Unit = {
    _longitude = longitude
  }

  def useCount: Option[Int] = _useCount
  def useCount_=(useCount: Option[Int]): Unit = {
    _useCount = useCount
  }

  def id: Option[String] = _id
  def id_=(id: Option[String]): Unit = {
    _id = id
  }

  def name: Option[String] = _name
  def name_=(name: Option[String]): Unit = {
    _name = name
  }

  def quality: Option[Int] = _quality
  def quality_=(quality: Option[Int]): Unit = {
    _quality = quality
  }

  def contribution: Option[Double] = _contribution
  def contribution_=(contribution: Option[Double]): Unit = {
    _contribution = contribution
  }
}
