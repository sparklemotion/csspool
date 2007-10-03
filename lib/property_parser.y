class CSS::SAC::GeneratedProperyParser

token ANGLE

rule
  property
    : azimuth
    | background_attachment
    | background_color
    | background_image
    | background_position
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
  background_color
    : 'background-color' COLOR
    | 'background-color' 'transparent'
    | 'background-color' 'inherit'
    ;
  background_image
    : 'background-image' URI
    | 'background-image' 'color'
    | 'background-image' 'inherit'
    ;
  background_position
    : 'background-position' pl_left_center_right optional_pl_top_center_bottom
    | 'background-position' left_center_right
    | 'background-position' top_center_bottom
    | 'background-position' 'inherit'
    ;
  pl_left_center_right
    : PERCENTAGE
    | LENGTH
    | left_center_right
    ;
  left_center_right
    : 'left'
    | 'center'
    | 'right'
    ;
  optional_pl_top_center_bottom
    : PERCENTAGE
    | LENGTH
    | top_center_bottom
    |
    ;
  top_center_bottom
    : 'top'
    | 'center'
    | 'bottom'
    ;
