require_relative '../dependency_loader'

describe ImageProcessor do
  
  it "has an image file" do
    image = ImageProcessor.new("./test/images/image_with_coordinates.jpg")
    expect(image.src).to eq "./test/images/image_with_coordinates.jpg"
  end

  it "throws exception on invalid image" do
    expect{ImageProcessor.new("./test/images/non_supported_image.png")}.to raise_error(EXIFR::MalformedJPEG)
  end

  it "throws exception on invalid image" do
    expect{ImageProcessor.new("./test/images/non_existant_image.png")}.to raise_error(Errno::ENOENT)
  end

  it "should return gps coordinates for image with coordinates" do
    image = ImageProcessor.new("./test/images/image_with_coordinates.jpg")
    expect(image.gps_coordinates).to eq([50.09133333333333, -122.94566666666667])
  end

  it "should return blank for image without coordinates" do
    image = ImageProcessor.new("./test/images/image_without_coordinates.jpg")
    expect(image.gps_coordinates).to eq(['', ''])
  end

  it "should give file name of valid image" do
    image = ImageProcessor.new('./test/images/image_with_coordinates.jpg')
    expect(image.file_name).to eq('image_with_coordinates.jpg')
  end

  it "should give dimensions of valid image" do
    image = ImageProcessor.new('./test/images/image_with_coordinates.jpg')
    expect(image.dimensions).to eq('2048x1536')
  end

  it "should give longitude of valid image with coordinates" do
    image = ImageProcessor.new('./test/images/image_with_coordinates.jpg')
    expect(image.longitude).to eq(-122.94566666666667)
  end 

  it "should give latitude of valid image with coordinates" do
    image = ImageProcessor.new('./test/images/image_with_coordinates.jpg')
    expect(image.latitude).to eq(50.09133333333333)
  end 

  # it "should give width of image" do 
  
end
