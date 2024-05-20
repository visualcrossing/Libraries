#include <vector>
#include <string>
using namespace std;

class WeatherHourlyData
{
	tm datetime;
	long datetimeEpoch;
	double temp;
	double feelslike;
	double humidity;
	double dew;
	double precip;
	double precipprob;
	double snow;
	double snowdepth;
	vector<string> preciptype;
	double windgust;
	double windspeed;
	double winddir;
	double pressure;
	double visibility;
	double cloudcover;
	double solarradiation;
	double solarenergy;
	double uvindex;
	string conditions;
	string icon;
	vector<string> stations;
	string source;

public:
	tm getDatetime();
	void setDatetime(tm);

	long getDatetimeEpoch();
	void setDatetimeEpoch(long);

	double getTemp();
	void setTemp(double);

	double getFeelslike();
	void setFeelslike(double);

	double getHumidity();
	void setHumidity(double);

	double getDew();
	void setDew(double);

	double getPrecip();
	void setPrecip(double);

	double getPrecipProb();
	void setPrecipProb(double);

	double getSnow();
	void setSnow(double);

	double getSnowDepth();
	void setSnowDepth(double);

	vector<string> getPrecipType();
	void setPrecipType(vector<string>);

	double getWindGust();
	void setWindGust(double);

	double getWindSpeed();
	void setWindSpeed(double);

	double getWindDir();
	void setWindDir(double);

	double getPressure();
	void setPressure(double);

	double getVisibility();
	void setVisibility(double);

	double getCloudCover();
	void setCloudCover(double);

	double getSolarRadiation();
	void setSolarRadiation(double);

	double getSolarEnergy();
	void setSolarEnergy(double);

	double getUvIndex();
	void setUvIndex(double);

	string getConditions();
	void setConditions(string);

	string getIcon();
	void setIcon(string);

	vector<string> getStations();
	void setStations(vector<string>);

	string getSource();
	void setSource(string);
};

