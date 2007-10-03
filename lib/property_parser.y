class CSS::SAC::GeneratedProperyParser

token ANGLE COLOR URI PERCENTAGE LENGTH

rule
  property
    : azimuth
    | background_attachment
    | background_color
    | background_image
    | background_position
    | background_repeat
    | background
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
    : 'background-attachment' background_attachment_values
    | 'background-attachment' 'inherit'
    ;
  background_attachment_values
    : 'scroll'
    | 'fixed'
    ;
  background_color
    : 'background-color' background_color_values
    | 'background-color' 'inherit'
    ;
  background_color_values
    : COLOR
    | 'transparent'
    ;
  background_image
    : 'background-image' background_image_values
    | 'background-image' 'inherit'
    ;
  background_image_values
    : URI
    | 'color'
    ;
  background_position
    : 'background-position' background_position_values
    | 'background-position' 'inherit'
    ;
  background_position_values
    : pl_left_center_right optional_pl_top_center_bottom
    | left_center_right
    | top_center_bottom
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
  background_repeat
    : 'background-repeat' background_repeat_values
    | 'background-repeat' 'inherit'
    ;
  background_repeat_values
    : 'repeat'
    | 'repeat-x'
    | 'repeat-y'
    | 'no-repeat'
    ;
  background
    : 'background' background_values
    | 'background' 'inherit'
    ;
  background_values
    : background_color_values
    | background_image_values
    | background_repeat_values
    | background_attachment_values
    | background_position_values
    ;
