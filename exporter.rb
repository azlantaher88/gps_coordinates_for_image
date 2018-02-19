class Exporter

  ALLOWED_FORMATS = ['csv', 'html'].freeze

  private
  attr_writer :filename, :dir_path, :file_path

  public
  attr_reader :file_path, :filename, :dir_path, :images

  def initialize(export_format, filename="gps_coordinates", path=Dir.pwd)
    puts export_format
    @export_format = export_format
    @dir_path = path
    @filename = "#{filename}.#{export_format}"
    @file_path = File.join(@dir_path, @filename)
    @images = []
    FileUtils.mkdir_p(@dir_path) unless File.exists?(@dir_path)
    FileUtils.touch(File.join(@dir_path, @filename))
  rescue e
    $stderr.puts "[ERROR] Failed to initialize exporter"
    raise e
  end

  def store_for_export(data)
    @images.push(data)
  end

  def export_as_csv
    result = "Name,Latitude, Longitude,\n"
    self.images.each do |image|
      result << "#{image[:name]},#{image[:latitude]},#{image[:longitude]}\n"
    end
    return result
  rescue e 
    $stderr.puts "[ERROR] Failed to generate csv"
    raise e
  end

  def export_as_html
    response = %{
      Images and their GPS Coordinates    
      <table style="border: 1px solid #1C6EA4;background-color: #EEEEEE;width: 100%;text-align: left;border-collapse: collapse;">
       <thead style="background: #1C6EA4;background: -moz-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);background: -webkit-linear-gradient(top, #5592bb 0%, #327cad 66%, #1C6EA4 100%);background: linear-gradient(to bottom, #5592bb 0%, #327cad 66%, #1C6EA4 100%);border-bottom: 2px solid #444444;">
         <tr>
           <th style="font-size: 15px;font-weight: bold;color: #FFFFFF;border-left: 2px solid #D0E4F5;border: 1px solid #AAAAAA;padding: 3px 2px;">Filename</th>
           <th>Latitude</th>
           <th>Longitude</th>
         </tr>
       </thead>
       <tbody>
         <% for image in self.images %>
           <tr>
             <td style="font-size: 13px;border: 1px solid #AAAAAA;padding: 3px 2px;"><%=image[:name]%></td>
             <td style="font-size: 13px;border: 1px solid #AAAAAA;padding: 3px 2px;"><%=image[:latitude]%></td>
             <td style="font-size: 13px;border: 1px solid #AAAAAA;padding: 3px 2px;"><%=image[:longitude]%></td>
           </tr>
         <% end %>
       </tbody>
      </table>
    }
    ERB.new(response).result(binding)
  rescue e
    $stderr.puts "[ERROR] Failed to generate html"
    raise e
  end

  def save_file
    File.open(@file_path, "w+") do |f|
      f.write(self.send("export_as_#{@export_format}"))
    end
  rescue e
    $stderr.puts "[ERROR] Failed to wirte data in #{@file_path}"
    raise e
  end
end