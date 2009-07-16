# require 'scruffy'
# require 'scruffy_extensions/data_markers'
require 'csv'
require 'erb'

module Trample
  class Statistics
    def initialize(log_file)
      @log_file = log_file
    end
    
    def produce_statistics
      data = parse_log_file
    end
    
    def parse_log_file
      complete_time = {}
      start_time = {}
      
      complete_time.default = 0
      start_time.default = 0
      
      data = []
      CSV.open(@log_file, 'r') do |row|
        next if row.size != 6
        row.each {|item| item.strip!}
        row[2].gsub!("s", '') 
        data << row
        
        complete_time[row[4]] += 1
        start_time[row[3]] += 1
        # row[0] = method
        # row[1] = url
        # row[2] = duration
        # row[3] = start
        # row[4] = complete
        # row[5] = code
      end
      durations = data.collect {|row| row[2].to_f}
      total_requests = durations.size
      total_duration = durations.inject(0) {|d, sum| d + sum}
      max_duration = durations.max
      min_duration = durations.min
      avg_duration = total_duration/total_requests
      timestamp = Time.now

      values = complete_time.keys.sort.collect{|key| complete_time[key]}
      start_values = start_time.keys.sort.collect{|key| start_time[key]}

      # Time to refactor
      graph = Scruffy::Graph.new
      graph.title = "Trample Concurrent Requests"
      graph.renderer = Scruffy::Renderers::Standard.new
      filename = 'trample'
      
      adjusted_values, point_markers = scale_values_for_graph(values)
      graph.add :simple_line, '# of Requests/Second', start_values
      graph.add :simple_line, '# of Responses/Second', adjusted_values
      graph.point_markers = point_markers
      img_file_name = "#{filename}.png"
      graph.render  :width => 1000, :height => 400,
         :to => img_file_name, :as => 'png'
      
       # Time to refactor
       graph = Scruffy::Graph.new
       graph.title = "Trample Boxplot"
       graph.renderer = Scruffy::Renderers::Standard.new
       boxplot_filename = 'trample_boxplot'

       graph.add :box_plot, 'Response Duration (in sec)', durations
       boxplot_file_name = "#{boxplot_filename}.png"
       graph.render  :width => 1000, :height => 400,
          :to => boxplot_file_name, :as => 'png'

      template = File.read(TEMPLATE_ROOT + "/statistics.html.erb")
      rhtml = ERB.new(template)
      File.open('index.html', 'w') do |f|
        f.write(rhtml.result(binding))
      end
      
      data
    end
    
    def scale_values_for_graph(values)
      max_slots = 20
      step = values.size / max_slots + 1
      data_slots = (values.size < max_slots ? values.size : max_slots)
      # adjusted_values = [0] * data_slots
      # (0..values.size - 1).each do |index|
      #   adjusted_values[index/step] += values[index]
      # end
      point_markers = (0..data_slots).collect{|x| x * step}.uniq
      [values, point_markers]
    end
  end
end

    