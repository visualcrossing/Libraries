#include <string>

using namespace std;

class Station
{
	double distance;
	double latitude;
	double longitude;
	int useCount;
	string id;
	string name;
	int quality;
	double contribution;

public:
	double getDistance();
	void setDistance(double);

	double getLatitude();
	void setLatitude(double);

	double getLongitude();
	void setLongitude(double);

	int getUseCount();
	void setUseCount(int);

	string getId();
	void setId(string);

	string getName();
	void setName(string);

	int getQuality();
	void setQuality(int);

	double getContribution();
	void setContribution(double);
};

