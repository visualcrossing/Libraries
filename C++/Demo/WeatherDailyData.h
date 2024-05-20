#include <string>
#include <vector>
#include "Event.h"
#include "WeatherHourlyData.h"
using namespace std;

class WeatherDailyData
{
	tm datetime;
	long datetimeEpoch;
	double tempmax, tempmin, temp;
	double feelslikemax, feelslikemin, feelslike;
	double dew;
	double humidity;
	double precip, precipprob, precipcover;
	vector<string> preciptype;
	double snow, snowdepth;
	double windgust, windspeed, winddir;
	double pressure;
	double cloudcover;
	double visibility;
	double solarradiation, solarenergy;
	double uvindex;
	string sunrise;
	long sunriseEpoch;
	string sunset;
	long sunsetEpoch;
	double moonphase;
	string conditions;
	string description;
	string icon;
	vector<string> stations;
	string source;
	vector<Event> events;
	vector<WeatherHourlyData> hourlyData;
public:

	vector<WeatherHourlyData>& getHourlyData();
	void setHourlyData(vector<WeatherHourlyData>);

	tm getDatetime();
	void setDatetime(tm);

	long getDatetimeEpoch();
	void setDatetimeEpoch(long);

	double getTempMax();
	void setTempMax(double);

	double getTempMin();
	void setTempMin(double);

	double getTemp();
	void setTemp(double);

	double getFeelslikeMax();
	void setFeelslikeMax(double);

	double getFeelslikeMin();
	void setFeelslikeMin(double);

	double getFeelslike();
	void setFeelslike(double);

	double getDew();
	void setDew(double);

	double getHumidity();
	void setHumidity(double);

	double getPrecip();
	void setPrecip(double);

	double getPrecipProb();
	void setPrecipProb(double);

	double getPrecipCover();
	void setPrecipCover(double);

	vector<string> getPrecipType();
	void setPrecipType(vector<string>);

	double getSnow();
	void setSnow(double);

	double getSnowDepth();
	void setSnowDepth(double);

	double getWindGust();
	void setWindGust(double);

	double getWindSpeed();
	void setWindSpeed(double);

	double getWindDir();
	void setWindDir(double);

	double getPressure();
	void setPressure(double);

	double getCloudCover();
	void setCloudCover(double);

	double getVisibility();
	void setVisibility(double);

	double getSolarRadiation();
	void setSolarRadiation(double);

	double getSolarEnergy();
	void setSolarEnergy(double);

	double getUvIndex();
	void setUvIndex(double);

	string getSunRise();
	void setSunRise(string);

	long getSunRiseEpoch();
	void setSunRiseEpoch(long);

	string getSunSet();
	void setSunSet(string);

	long getSunSetEpoch();
	void setSunSetEpoch(long);

	double getMoonPhase();
	void setMoonPhase(double);

	string getConditions();
	void setConditions(string);

	string getDescription();
	void setDescription(string);

	string getIcon();
	void setIcon(string);

	vector<string> getStations();
	void setStations(vector<string>);

	vector<Event>& getEvents();
	void setEvents(vector<Event>);

	string getSource();
	void setSource(string);
};

