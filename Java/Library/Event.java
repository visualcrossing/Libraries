import java.time.LocalDateTime;

public class Event {
    private LocalDateTime datetime;
    private Long datetimeEpoch;
    private String type;
    private Double latitude;
    private Double longitude;
    private Double distance;
    private String description;
    private Double size;

    public LocalDateTime getDatetime() {
        return datetime;
    }
    public void setDatetime(LocalDateTime datetime) { this.datetime = datetime; }

    public Long getDatetimeEpoch() { return datetimeEpoch; }
    public void setDatetimeEpoch(Long datetimeEpoch) { this.datetimeEpoch = datetimeEpoch; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Double getDistance() { return distance; }
    public void setDistance(Double distance) { this.distance = distance; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getSize() { return size; }
    public void setSize(Double size) { this.size = size; }
}
