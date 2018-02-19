require_relative '../dependency_loader'

describe Exporter do
  it "should initialize with csv as format" do
    exporter = Exporter.new('csv')
    expect(exporter.export_format).to eq('csv')
  end

  it "should be able to update images array" do
    exporter = Exporter.new('csv')
    exporter.store_for_export({name: 'any', latitude: 1, longitude: 2 })
    expect(exporter.images).to eq([{name: 'any', latitude: 1, longitude: 2 }])
  end
end