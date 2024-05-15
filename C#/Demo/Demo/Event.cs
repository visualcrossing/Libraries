using System;

namespace Library
{
    public class Event
    {
        private DateTime _datetime;
        private long? _datetimeEpoch;
        private string _type;
        private double? _latitude;
        private double? _longitude;
        private double? _distance;
        private string _description;
        private double? _size;

        // Constructor
        public Event() { }

        // Properties with explicit getters and setters
        public DateTime Datetime
        {
            get { return _datetime; }
            set { _datetime = value; }
        }

        public long? DatetimeEpoch
        {
            get { return _datetimeEpoch; }
            set { _datetimeEpoch = value; }
        }

        public string Type
        {
            get { return _type; }
            set { _type = value; }
        }

        public double? Latitude
        {
            get { return _latitude; }
            set { _latitude = value; }
        }

        public double? Longitude
        {
            get { return _longitude; }
            set { _longitude = value; }
        }

        public double? Distance
        {
            get { return _distance; }
            set { _distance = value; }
        }

        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        public double? Size
        {
            get { return _size; }
            set { _size = value; }
        }
    }

}
