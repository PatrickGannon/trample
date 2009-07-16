module Scruffy::Layers
  # ==Scruffy::Layers::SimpleLine
  #
  # Author:: Mark Morga, Sameer Chowdhury
  # Date:: July 14, 2009
  #
  # Simple Line graph - thinner lines, no circles at data points
  class SimpleLine < Base
    
    # Renders line graph.
    def draw(svg, coords, options={})
      svg.g(:class => 'shadow', :transform => "translate(#{relative(0.5)}, #{relative(0.5)})") {
        svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'transparent', 
                      :stroke => 'black', 'stroke-width' => relative(0.5), 
                      :style => 'fill-opacity: 0; stroke-opacity: 0.35' )
      }


      svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'none', 
                    :stroke => color.to_s, 'stroke-width' => relative(0.5) )
    end
  end
end