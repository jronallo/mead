require 'helper'

class TestBarcode < Test::Unit::TestCase
  context 'barcode creator' do
    setup do
      mead_file = File.open('test/ead/ua023_031.xml')
      @mead1 = Mead::Identifier.new('ua023_031-001-cb0003-005-001', mead_file).extract
      @mead2 = Mead::Identifier.new('ua023_031-001-cb0013-019A-001', mead_file).extract
      @barcode1 = Mead::Barcode.new(@mead1)
    end
    should 'hold an instance of a mead' do
      assert_equal Mead::Identifier, @barcode1.mead.class
    end
    should 'create a barcode file' do
      png_file_path = @barcode1.output_barcode(File.expand_path(File.join(File.dirname(__FILE__), '..')))
      assert File.exists?(png_file_path)
      File.delete(png_file_path)
    end
    should 'create a text file' do
      text_file_path = @barcode1.output_label(File.expand_path(File.join(File.dirname(__FILE__), '..')))
      assert File.exists?(text_file_path)
      File.delete(text_file_path)
    end
  end
end
