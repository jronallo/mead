module Mead
  class Barcode
    attr_accessor :mead
    
    def initialize(identifier)
      @mead = identifier
    end
    
    def output_barcode(directory)
      bc = Gbarcode.barcode_create(@mead.mead)
      bc.scalef = 0.5
      bc.margin = 25
      Gbarcode.barcode_encode(bc, Gbarcode::BARCODE_128)
      #tempfile for eps version of barcode
      eps_path = File.join(directory, @mead.mead + '.eps')
      png_path = File.join(directory, @mead.mead + '-barcode.png')
      eps = File.new(eps_path, 'w')      
      Gbarcode.barcode_print(bc, eps, Gbarcode::BARCODE_OUT_EPS)
      eps.close      
      `convert +antialias #{eps_path} -background white -flatten #{png_path}`
      File.delete(eps_path)
      png_path      
    end
    
    def output_label(directory)
      png_path = output_barcode(directory)
      text_path = File.join(directory, @mead.mead + '-text.png')
      label_path = File.join(directory, @mead.mead + '-label.png')
      `convert -pointsize 24 -background white -fill black label:'#{label_text}' #{text_path}`
      text_path
      # convert *.png -resize 75% -append output.png
      `convert #{png_path} #{text_path} -append #{label_path}`
      File.delete(png_path)
      File.delete(text_path)
      label_path
    end
    
    def label_text
      text = [@mead.mead]
      text << @mead.metadata.first[:unittitle]
      text << @mead.metadata.first[:item_location]
      text.join('\n')
    end
    
  end
end
