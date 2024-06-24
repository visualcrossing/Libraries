use std::option::Option;
use chrono::NaiveDate;

pub struct Event {
    datetime: Option<NaiveDate>,
    datetime_epoch: Option<u64>,
    event_type: Option<String>,
    latitude: Option<f64>,
    longitude: Option<f64>,
    distance: Option<f64>,
    description: Option<String>,
    size: Option<f64>,
}

impl Event {
    // Constructor
    pub fn new() -> Event {
        Event {
            datetime: None,
            datetime_epoch: None,
            event_type: None,
            latitude: None,
            longitude: None,
            distance: None,
            description: None,
            size: None,
        }
    }

    // Getters and setters
    pub fn datetime(&self) -> Option<NaiveDate> {
        self.datetime
    }

    pub fn set_datetime(&mut self, datetime: Option<NaiveDate>) {
        self.datetime = datetime;
    }

    pub fn datetime_epoch(&self) -> Option<u64> {
        self.datetime_epoch
    }

    pub fn set_datetime_epoch(&mut self, datetime_epoch: Option<u64>) {
        self.datetime_epoch = datetime_epoch;
    }

    pub fn event_type(&self) -> &Option<String> {
        &self.event_type
    }

    pub fn set_event_type(&mut self, event_type: Option<String>) {
        self.event_type = event_type;
    }

    pub fn latitude(&self) -> Option<f64> {
        self.latitude
    }

    pub fn set_latitude(&mut self, latitude: Option<f64>) {
        self.latitude = latitude;
    }

    pub fn longitude(&self) -> Option<f64> {
        self.longitude
    }

    pub fn set_longitude(&mut self, longitude: Option<f64>) {
        self.longitude = longitude;
    }

    pub fn distance(&self) -> Option<f64> {
        self.distance
    }

    pub fn set_distance(&mut self, distance: Option<f64>) {
        self.distance = distance;
    }

    pub fn description(&self) -> &Option<String> {
        &self.description
    }

    pub fn set_description(&mut self, description: Option<String>) {
        self.description = description;
    }

    pub fn size(&self) -> Option<f64> {
        self.size
    }

    pub fn set_size(&mut self, size: Option<f64>) {
        self.size = size;
    }
}
