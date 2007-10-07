class CSS::SAC::GeneratedProperyParser

token ANGLE COLOR URI PERCENTAGE LENGTH EMS EXS

rule
  property
    : azimuth
    | background_attachment
    | background_color
    | background_image
    | background_position
    | background_repeat
    | background
    | border_collapse
    | border_color
    | border_spacing
    | border_style
    | border_trbl
    | border_trbl_color
    | border_trbl_style
    | border_trbl_width
    ;
  length
    : LENGTH
    | EMS
    | EXS
    ;
  color
    : COLOR
    | 'aqua'
    | 'black'
    | 'blue'
    | 'fuchsia'
    | 'gray'
    | 'green'
    | 'lime'
    | 'maroon'
    | 'navy'
    | 'olive'
    | 'orange'
    | 'purple'
    | 'red'
    | 'silver'
    | 'teal'
    | 'white'
    | 'yellow'
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
    : color
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
    | length
    | left_center_right
    ;
  left_center_right
    : 'left'
    | 'center'
    | 'right'
    ;
  optional_pl_top_center_bottom
    : PERCENTAGE
    | length
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
  border_collapse
    : 'border-collapse' border_collapse_values
    | 'border-collapse' 'inherit'
    ; 
  border_collapse_values
    : 'collapse'
    | 'separate'
    ;
  border_color
    : 'border-color' border_color_values
    | 'border-color' 'inherit'
    ;
  border_color_values
    : color_or_transparent color_or_transparent color_or_transparent
      color_or_transparent
    | color_or_transparent color_or_transparent color_or_transparent
    | color_or_transparent color_or_transparent
    | color_or_transparent
    ;
  color_or_transparent
    : color
    | 'transparent'
    ;
  border_spacing
    : 'border-spacing' border_spacing_values
    | 'border-spacing' 'inherit'
    ;
  border_spacing_values
    : length length
    | length
    ;
  border_style
    : 'border-style' border_style_values_1to4
    | 'border-style' 'inherit'
    ;
  border_style_values_1to4
    : border_style_values border_style_values border_style_values
      border_style_values
    | border_style_values border_style_values border_style_values
    | border_style_values border_style_values
    | border_style_values
    ;
  border_style_values
    : 'none'
    | 'hidden'
    | 'dotted'
    | 'dashed'
    | 'solid'
    | 'double'
    | 'groove'
    | 'ridge'
    | 'inset'
    | 'outset'
    ;
  border_trbl
    : border_trbl_keys border_trbl_values
    | border_trbl_keys 'inherit'
    ;
  border_trbl_keys
    : 'border-top'
    | 'border-right'
    | 'border-bottom'
    | 'border-left'
    ;
  border_trbl_values
    : border_width_values
    | border_style_values
    | border_trbl_color_values
    ;
  border_trbl_color
    : border_trbl_color_keys border_trbl_color_values
    | border_trbl_color_keys 'inherit'
    ;
  border_trbl_color_keys
    : 'border-top-color'
    | 'border-right-color'
    | 'border-bottom-color'
    | 'border-left-color'
    ;
  border_trbl_color_values
    : color
    ;
  border_trbl_style
    : border_trbl_style_keys border_style_values
    | border_trbl_style_keys 'inherit'
    ;
  border_trbl_style_keys
    : 'border-top-style'
    | 'border-right-style'
    | 'border-bottom-style'
    | 'border-left-style'
    ;
  border_trbl_width
    : border_trbl_width_keys border_width_values
    | border_trbl_width_keys 'inherit'
    ;
  border_trbl_width_keys
    : 'border-top-width'
    | 'border-right-width'
    | 'border-bottom-width'
    | 'border-left-width'
    ;
  border_width
    : 'border-width' border_width_values_1to4
    | 'border-width' 'inherit'
    ;
  border_width_values
    : 'thin'
    | 'medium'
    | 'thick'
    | length
    ;
  border_width_values_1to4
    : border_width_values border_width_values border_width_values
      border_width_values
    | border_width_values border_width_values border_width_values
    | border_width_values border_width_values
    | border_width_values
    ;
