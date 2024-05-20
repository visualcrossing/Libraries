#include "Station.h"

double Station::getDistance() {
	return distance;
}

void Station::setDistance(double d) {
	distance = d;
}

double Station::getLatitude() {
	return latitude;
}

void Station::setLatitude(double l) {
	latitude = l;
}

double Station::getLongitude() {
	return longitude;
}

void Station::setLongitude(double l) {
	longitude = l;
}

int Station::getUseCount() {
	return useCount;
}

void Station::setUseCount(int u) {
	useCount = u;
}

string Station::getId() {
	return id;
}

void Station::setId(string i) {
	id = i;
}

string Station::getName() {
	return name;
}

void Station::setName(string n) {
	name = n;
}

int Station::getQuality() {
	return quality;
}

void Station::setQuality(int q) {
	quality = q;
}

double Station::getContribution() {
	return contribution;
}

void Station::setContribution(double c) {
	contribution = c;
}