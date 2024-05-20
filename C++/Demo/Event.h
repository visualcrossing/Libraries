#include <time.h>
#include <string>

using namespace std;

class Event
{
	tm datetime;
	long datetimeEpoch;
	string type;
	double latitude;
	double longitude;
	double distance;
	string description;
	double size;

public:
	tm getDatetime();
	void setDatetime(tm);

	long getDatetimeEpoch();
	void setDatetimeEpoch(long);

	string getType();
	void setType(string);

	double getLatitude();
	void setLatitude(double);

	double getLongitude();
	void setLongitude(double);

	double getDistance();
	void setDistance(double);

	string getDescription();
	void setDescription(string);

	double getSize();
	void setSize(double);
};

