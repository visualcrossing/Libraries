Namespace Library

    Public Class WStation
        Private _distance As Double?
        Private _latitude As Double?
        Private _longitude As Double?
        Private _useCount As Integer?
        Private _id As String
        Private _name As String
        Private _quality As Integer?
        Private _contribution As Double?

        Public Property Distance() As Double?
            Get
                Return _distance
            End Get
            Set(ByVal value As Double?)
                _distance = value
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

        Public Property UseCount() As Integer?
            Get
                Return _useCount
            End Get
            Set(ByVal value As Integer?)
                _useCount = value
            End Set
        End Property

        Public Property Id() As String
            Get
                Return _id
            End Get
            Set(ByVal value As String)
                _id = value
            End Set
        End Property

        Public Property Name() As String
            Get
                Return _name
            End Get
            Set(ByVal value As String)
                _name = value
            End Set
        End Property

        Public Property Quality() As Integer?
            Get
                Return _quality
            End Get
            Set(ByVal value As Integer?)
                _quality = value
            End Set
        End Property

        Public Property Contribution() As Double?
            Get
                Return _contribution
            End Get
            Set(ByVal value As Double?)
                _contribution = value
            End Set
        End Property
    End Class

End Namespace