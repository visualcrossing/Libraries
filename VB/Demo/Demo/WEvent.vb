Imports System

Namespace Library

    Public Class WEvent
        Private _datetime As DateTime
        Private _datetimeEpoch As Long?
        Private _type As String
        Private _latitude As Double?
        Private _longitude As Double?
        Private _distance As Double?
        Private _description As String
        Private _size As Double?

        Public Property Datetime() As DateTime
            Get
                Return _datetime
            End Get
            Set(ByVal value As DateTime)
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

        Public Property Type() As String
            Get
                Return _type
            End Get
            Set(ByVal value As String)
                _type = value
            End Set
        End Property

        Public Property Latitude() As Double?
            Get
                Return _latitude
            End Get
            Set(ByVal value As Double?)
                _latitude = value
            End Set
        End Property

        Public Property Longitude() As Double?
            Get
                Return _longitude
            End Get
            Set(ByVal value As Double?)
                _longitude = value
            End Set
        End Property

        Public Property Distance() As Double?
            Get
                Return _distance
            End Get
            Set(ByVal value As Double?)
                _distance = value
            End Set
        End Property

        Public Property Description() As String
            Get
                Return _description
            End Get
            Set(ByVal value As String)
                _description = value
            End Set
        End Property

        Public Property Size() As Double?
            Get
                Return _size
            End Get
            Set(ByVal value As Double?)
                _size = value
            End Set
        End Property
    End Class
End Namespace