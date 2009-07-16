module Scruffy::Layers
  # ==Scruffy::Layers::BoxPlot
  #
  # Author:: Mark Morga & Sameer Chowdhury
  # Date:: July 14th, 2006
  #
  # BoxPlot graph.
  class BoxPlot < Base
    
    attr_accessor :extreme_outliers, :outliers, :iqr, :x025, :x050, :x075, :mean
    
    def draw(svg, coords, options={})
      center = width / 2
      x = center - (@box_width / 2)
      
      # Draw the box
      svg.rect( :x => x, :y => @x025, :width => @box_width, :height => @x075 - @x025, 
                :fill => 'none', 'style' => "opacity: #{opacity}; stroke: aquamarine; stroke-width: 2;" )

      # Draw the median
      svg.line(:x1 => x, :y1 => @x050, :x2 => x + @box_width, :y2 => @x050, :style => "stroke: aquamarine; stroke-width: 2;")

      # Draw the mean
      svg.line(:x1 => x, :y1 => @mean, :x2 => x + @box_width, :y2 => @mean, :style => "stroke: aquamarine; stroke-dasharray: 5, 5; stroke-width: 2;")

      # Draw the low whisker
      svg.line(:x1 => center, :y1 => @x025, :x2 => center, :y2 => @low_whisker, :style => "stroke: aquamarine; stroke-dasharray: 5, 5; stroke-width: 2;")
      svg.line(:x1 => x, :y1 => @low_whisker, :x2 => x + @box_width, :y2 => @low_whisker, :style => "stroke: aquamarine; stroke-width: 2;")

      # Draw the high whisker
      svg.line(:x1 => center, :y1 => @x075, :x2 => center, :y2 => @high_whisker, :style => "stroke: aquamarine; stroke-dasharray: 5, 5; stroke-width: 2;")
      svg.line(:x1 => x, :y1 => @high_whisker, :x2 => x + @box_width, :y2 => @high_whisker, :style => "stroke: aquamarine; stroke-width: 2;")

      # Draw the outliers
      @outliers.each do |outlier|
        svg.circle( :cx => center, :cy => outlier, :r => relative(0.25), 
                                            :style => "stroke-width: 0.25; stroke: gold" )
      end

      # Draw the extreme outliers
      @extreme_outliers.each do |outlier|
        svg.circle( :cx => center, :cy => outlier, :r => relative(0.25), 
                                            :style => "stroke-width: 0.25; stroke: red; fill: red" )
      end
    end
    
    def generate_coordinates(options = {})
      @box_width = width * 0.3

      points.sort!
      x025_index = (points.size * 0.25).to_i
      x050_index = (points.size * 0.5).to_i
      x075_index = (points.size * 0.75).to_i
      iqr = points[x075_index] - points[x025_index] 
      mean = (points.inject(0) {|d, sum| d + sum}).to_f / points.size.to_f

      @extreme_outliers = []
      @outliers = []
      @low_whisker = max_value + 1
      @high_whisker = min_value - 1
      outlier_min = points[x025_index] - (1.5 * iqr)
      outlier_max = points[x075_index] + (1.5 * iqr)
      extreme_min = points[x025_index] - (3.0 * iqr)
      extreme_max = points[x075_index] + (3.0 * iqr)
      points.each do |point|
        if point < extreme_min or point > extreme_max
          @extreme_outliers << scale_for_layer(point)
        elsif point < outlier_min or point > outlier_max
          @outliers << scale_for_layer(point)
        elsif @low_whisker > point  and point >= outlier_min 
          @low_whisker = point
        elsif @high_whisker < point and point <= outlier_max
          @high_whisker = point
        end
      end

      puts "\n\nData for boxplot\n"
      puts "high whisker: #{@high_whisker}"
      puts "75th percentile: #{points[x075_index]}"
      puts "median: #{points[x050_index]}"
      puts "mean: #{mean}"
      puts "25th percentile: #{points[x025_index]}"
      puts "low whisker: #{@low_whisker}"
      
      @low_whisker = scale_for_layer(@low_whisker)
      @high_whisker = scale_for_layer(@high_whisker)
      @x025 = scale_for_layer(points[x025_index])
      @x050 = scale_for_layer(points[x050_index])
      @x075 = scale_for_layer(points[x075_index])
      @mean = scale_for_layer(mean)            
    end
  
    def scale_for_layer(point)
      relative_percent = ((point == min_value) ? 0 : ((point - min_value) / (max_value - min_value).to_f))
      y = (height - (height * relative_percent))
      y
    end
    
    # Optimistic generation of coordinates for layer to use.  These coordinates are
    # just a best guess, and can be overridden or thrown away (for example, this is overridden
    # in pie charting and bar charts).
    # def generate_coordinates(options = {})
    #   options[:point_distance] = width / (points.size - 1).to_f
    # 
    #   points.inject_with_index([]) do |memo, point, idx|
    #     x_coord = options[:point_distance] * idx
    # 
    #     if point
    #       relative_percent = ((point == min_value) ? 0 : ((point - min_value) / (max_value - min_value).to_f))
    #       y_coord = (height - (height * relative_percent))
    # 
    #       memo << [x_coord, y_coord]
    #     end
    #     
    #     memo
    #   end
    # end    
  end
end