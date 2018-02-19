# '/Users/arsalantahir/Downloads/orders_combined.xlsx'
# '/Users/arsalantahir/Downloads/gps_images/image_a.jpg'

class ImageProcessor

  private
  attr_reader :exifr_processor

  public
  attr_reader :src

  def initialize(path)
    call_with_path_and_rescue path do
      @src = path
      @exifr_processor = EXIFR::JPEG.new(@src)
    end
  end

  def src=(path)
    call_with_path_and_rescue path do
      @src = path
      @exifr_processor = EXIFR::JPEG.new(@src)
    end
  end

  def file_name
    puts src
    File.basename src
  end

  def dimensions
    "#{width}x#{height}"
  end

  def width
    @exifr_processor.width
  end

  def height
    @exifr_processor.height
  end

  def gps_coordinates
    if latitude || longitude
      [latitude, longitude]
    else
      ""
    end
  end

  def latitude
    @exifr_processor.gps.latitude rescue ""
  end

  def longitude
    @exifr_processor.gps.longitude rescue ""
  end

  private
  def call_with_path_and_rescue(path)    
    yield(path) if block_given?

  rescue EXIFR::MalformedJPEG => e
    $stderr.puts "[ERROR] Supplied file is not a valid jpeg file, , discarding parameters"
    @src = nil
    raise e
  rescue Errno::ENOENT => e
    $stderr.puts "[ERROR] No file at '#{src}' exists, please retry with valid path"
    @src = nil
    raise e
  rescue e
    $stderr.puts "[ERROR] Make sure you are passing all the required and valid parameters for processing, discarding parameters"
    @src = nil
    raise e
  end
end