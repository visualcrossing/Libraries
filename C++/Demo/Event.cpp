#include "Event.h"

tm Event::getDatetime() {
	return datetime;
}

void Event::setDatetime(tm t) {
	datetime = t;
}

long Event::getDatetimeEpoch() {
	return datetimeEpoch;
}

void Event::setDatetimeEpoch(long d) {
	datetimeEpoch = d;
}

string Event::getType() {
	return type;
}

void Event::setType(string t) {
	type = t;
}

double Event::getLatitude() {
	return latitude;
}

void Event::setLatitude(double l) {
	latitude = l;
}

double Event::getLongitude() {
	return longitude;
}

void Event::setLongitude(double l) {
	longitude = l;
}

double Event::getDistance() {
	return distance;
}

void Event::setDistance(double d) {
	distance = d;
}

string Event::getDescription() {
	return description;
}

void Event::setDescription(string d) {
	description = d;
}

double Event::getSize() {
	return size;
}

void Event::setSize(double s) {
	size = s;
}