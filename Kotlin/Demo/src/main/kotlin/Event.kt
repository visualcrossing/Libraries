
import java.time.LocalDateTime

class Event {
    var datetime: LocalDateTime? = null
        get() = field
        set(value) {
            field = value
        }

    var datetimeEpoch: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var type: String? = null
        get() = field
        set(value) {
            field = value
        }

    var latitude: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var longitude: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var distance: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var description: String? = null
        get() = field
        set(value) {
            field = value
        }

    var size: Double? = null
        get() = field
        set(value) {
            field = value
        }
}
