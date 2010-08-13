$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'open-uri'

require 'rubygems'
require 'nokogiri'
require 'csv'
if CSV.const_defined? :Reader
  require 'fastercsv'
end

#require 'active_support'
require 'active_support/core_ext/object/blank'

module Mead
  CONTAINER_MAPPING = {
    'am' => 'album',
    'ab' => 'artifactbox',
    'ac' => 'audiocassette',
    'at' => 'audiotape',
    'bx' => 'box',
    'cb' => 'cardbox',
    'cn' => 'carton',
    'ce' => 'cassette',
    'cx' => 'cassettebox',
    'cd' => 'cdbox',
    'de' => 'diskette',
    'db' => 'drawingsbox',
    'fb' => 'flatbox',
    'fe' => 'flatfile',
    'ff' => 'flatfolder',
    'fr' => 'folder',
    'hb' => 'halfbox',
    'im' => 'item',
    'le' => 'largeenvelope',
    'lb' => 'legalbox',
    'mc' => 'mapcase',
    'mf' => 'mapfolder',
    'nb' => 'notecardbox',
    'ot' => 'othertype',
    'oe' => 'oversize',
    'ox' => 'oversizebox',
    'of' => 'oversizeflatbox',
    'rl' => 'reel',
    'rb' => 'reelbox',
    'sk' => 'scrapbook',
    'sb' => 'slidebox',
    'te' => 'tube',
    'vt' => 'videotape',
    've' => 'volume'
  }
end

require 'mead/validations'
require 'mead/identifier'
require 'mead/extractor'
require 'mead/ead'
require 'mead/ead_validator'

# if gbarcode and rmagick can both be loaded then load mead/barcode
begin
  require 'gbarcode'
  begin
    require 'RMagick'
    require 'tempfile'
    require 'mead/barcode'
  rescue
  end  
rescue
end
