class CSS::SAC::GeneratedProperyParser

token ANGLE

rule
  property
    : azimuth
    | background_attachment
    ;
  azimuth
    : 'azimuth' ANGLE
    | 'azimuth' 'left-side'
    | 'azimuth' 'far-left'
    | 'azimuth' 'left'
    | 'azimuth' 'center-left'
    | 'azimuth' 'center'
    | 'azimuth' 'center-right'
    | 'azimuth' 'right'
    | 'azimuth' 'far-right'
    | 'azimuth' 'right-side'
    | 'azimuth' 'behind'
    | 'azimuth' 'leftwards'
    | 'azimuth' 'rightwards'
    | 'azimuth' 'inherit'
    ;
  background_attachment
    : 'background-attachment' 'scroll'
    | 'background-attachment' 'fixed'
    | 'background-attachment' 'inherit'
    ;

