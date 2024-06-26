use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'WeatherVisual',
    VERSION_FROM => 'lib/WeatherVisual.pm', # finds $VERSION
    PREREQ_PM    => {
        'LWP::UserAgent'          => 0,
        'JSON'                    => 0,
        'DateTime::Format::Strptime' => 0,
        'Exporter'                => 0,
        'WeatherVisual::Constants'=> 0,
        'WeatherVisual::Utils'    => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/WeatherVisual.pm', # retrieve abstract from module
       AUTHOR        => 'VisualCrossing <your.email@example.com>') : ()),
);
