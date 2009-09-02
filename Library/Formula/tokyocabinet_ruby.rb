require 'brewkit'
require File.expand_path(File.dirname(__FILE__)+'/tokyocabinet')

class TokyocabinetRuby < Tokyocabinet
  @url= "#{Tokyocabinet.url_base}/rubypkg/tokyocabinet-ruby-1.29.tar.gz"
  @md5='e5259b9c9c0368aa88a2accd6f3b9db4'
  @version = "1.29"
  
  def dep
    LibraryDep.new 'tokyocabinet'
  end
  
  def install cabinet_prefix=nil
    cabinet_prefix = Formula.factory('tokyocabinet').prefix unless cabinet_prefix
    system 'rm -f Makefile'
    system "ruby extconf.rb --with-tokyocabinet-dir=#{cabinet_prefix}"
    system "make install"
  end
end
