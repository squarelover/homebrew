require 'brewkit'
require File.expand_path(File.dirname(__FILE__)+'/tokyocabinet')

class Tokyodistopia < Tokyocabinet
  @url= "#{Tokyocabinet.url_base}/dystopiapkg/tokyodystopia-0.9.13.tar.gz"
  @homepage='http://tokyocabinet.sourceforge.net/'
  @md5='2418befbe1719d93ec00290da94bb92b'
  @version = "0.9.13"
  
  def deps
    LibraryDep.new 'tokyocabinet'
  end
  
  def ruby_libname
    nil
  end  
end