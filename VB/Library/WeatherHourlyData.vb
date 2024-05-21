﻿Imports System
Imports System.Collections.Generic

Namespace Library

    ''' <summary>
    ''' The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
    ''' temperature, feelslike, humidity, dew, precip, precipprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
    ''' pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
    ''' </summary>
    Public Class WeatherHourlyData
        Private _datetime As TimeSpan?
        Private _datetimeEpoch As Long?
        Private _temp As Double?
        Private _feelslike As Double?
        Private _humidity As Double?
        Private _dew As Double?
        Private _precip As Double?
        Private _precipprob As Double?
        Private _snow As Double?
        Private _snowdepth As Double?
        Private _preciptype As List(Of String)
        Private _windgust As Double?
        Private _windspeed As Double?
        Private _winddir As Double?
        Private _pressure As Double?
        Private _visibility As Double?
        Private _cloudcover As Double?
        Private _solarradiation As Double?
        Private _solarenergy As Double?
        Private _uvindex As Double?
        Private _conditions As String
        Private _icon As String
        Private _stations As List(Of String)
        Private _source As String

        ' Constructor
        Public Sub New()
            _preciptype = New List(Of String)()
            _stations = New List(Of String)()
        End Sub

        ' Properties
        Public Property Datetime() As TimeSpan?
            Get
                Return _datetime
            End Get
            Set(ByVal value As TimeSpan?)
                _datetime = value
            End Set
        End Property

        Public Property DatetimeEpoch() As Long?
            Get
                Return _datetimeEpoch
            End Get
            Set(ByVal value As Long?)
                _datetimeEpoch = value
            End Set
        End Property

        Public Property Temp() As Double?
            Get
                Return _temp
            End Get
            Set(ByVal value As Double?)
                _temp = value
            End Set
        End Property

        Public Property Feelslike() As Double?
            Get
                Return _feelslike
            End Get
            Set(ByVal value As Double?)
                _feelslike = value
            End Set
        End Property

        Public Property Humidity() As Double?
            Get
                Return _humidity
            End Get
            Set(ByVal value As Double?)
                _humidity = value
            End Set
        End Property

        Public Property Dew() As Double?
            Get
                Return _dew
            End Get
            Set(ByVal value As Double?)
                _dew = value
            End Set
        End Property

        Public Property Precip() As Double?
            Get
                Return _precip
            End Get
            Set(ByVal value As Double?)
                _precip = value
            End Set
        End Property

        Public Property PrecipProb() As Double?
            Get
                Return _precipprob
            End Get
            Set(ByVal value As Double?)
                _precipprob = value
            End Set
        End Property

        Public Property Snow() As Double?
            Get
                Return _snow
            End Get
            Set(ByVal value As Double?)
                _snow = value
            End Set
        End Property

        Public Property SnowDepth() As Double?
            Get
                Return _snowdepth
            End Get
            Set(ByVal value As Double?)
                _snowdepth = value
            End Set
        End Property

        Public Property PrecipType() As List(Of String)
            Get
                Return _preciptype
            End Get
            Set(ByVal value As List(Of String))
                _preciptype = value
            End Set
        End Property

        Public Property WindGust() As Double?
            Get
                Return _windgust
            End Get
            Set(ByVal value As Double?)
                _windgust = value
            End Set
        End Property

        Public Property WindSpeed() As Double?
            Get
                Return _windspeed
            End Get
            Set(ByVal value As Double?)
                _windspeed = value
            End Set
        End Property

        Public Property WindDir() As Double?
            Get
                Return _winddir
            End Get
            Set(ByVal value As Double?)
                _winddir = value
            End Set
        End Property

        Public Property Pressure() As Double?
            Get
                Return _pressure
            End Get
            Set(ByVal value As Double?)
                _pressure = value
            End Set
        End Property

        Public Property Visibility() As Double?
            Get
                Return _visibility
            End Get
            Set(ByVal value As Double?)
                _visibility = value
            End Set
        End Property

        Public Property CloudCover() As Double?
            Get
                Return _cloudcover
            End Get
            Set(ByVal value As Double?)
                _cloudcover = value
            End Set
        End Property

        Public Property SolarRadiation() As Double?
            Get
                Return _solarradiation
            End Get
            Set(ByVal value As Double?)
                _solarradiation = value
            End Set
        End Property

        Public Property SolarEnergy() As Double?
            Get
                Return _solarenergy
            End Get
            Set(ByVal value As Double?)
                _solarenergy = value
            End Set
        End Property

        Public Property UvIndex() As Double?
            Get
                Return _uvindex
            End Get
            Set(ByVal value As Double?)
                _uvindex = value
            End Set
        End Property

        Public Property Conditions() As String
            Get
                Return _conditions
            End Get
            Set(ByVal value As String)
                _conditions = value
            End Set
        End Property

        Public Property Icon() As String
            Get
                Return _icon
            End Get
            Set(ByVal value As String)
                _icon = value
            End Set
        End Property

        Public Property Stations() As List(Of String)
            Get
                Return _stations
            End Get
            Set(ByVal value As List(Of String))
                _stations = value
            End Set
        End Property

        Public Property Source() As String
            Get
                Return _source
            End Get
            Set(ByVal value As String)
                _source = value
            End Set
        End Property
    End Class
End Namespace