pub struct Station {
    distance: Option<f64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
    use_count: Option<i32>,
    id: Option<String>,
    name: Option<String>,
    quality: Option<i32>,
    contribution: Option<f64>,
}

impl Station {
    // Constructor
    pub fn new() -> Station {
        Station {
            distance: None,
            latitude: None,
            longitude: None,
            use_count: None,
            id: None,
            name: None,
            quality: None,
            contribution: None,
        }
    }

    // Getters and setters
    pub fn distance(&self) -> Option<f64> {
        self.distance
    }

    pub fn set_distance(&mut self, distance: Option<f64>) {
        self.distance = distance;
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

    pub fn use_count(&self) -> Option<i32> {
        self.use_count
    }

    pub fn set_use_count(&mut self, use_count: Option<i32>) {
        self.use_count = use_count;
    }

    pub fn id(&self) -> &Option<String> {
        &self.id
    }

    pub fn set_id(&mut self, id: Option<String>) {
        self.id = id;
    }

    pub fn name(&self) -> &Option<String> {
        &self.name
    }

    pub fn set_name(&mut self, name: Option<String>) {
        self.name = name;
    }

    pub fn quality(&self) -> Option<i32> {
        self.quality
    }

    pub fn set_quality(&mut self, quality: Option<i32>) {
        self.quality = quality;
    }

    pub fn contribution(&self) -> Option<f64> {
        self.contribution
    }

    pub fn set_contribution(&mut self, contribution: Option<f64>) {
        self.contribution = contribution;
    }
}
