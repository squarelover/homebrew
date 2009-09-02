require 'brewkit'
require File.expand_path(File.dirname(__FILE__)+'/tokyotyrant')

class TokyotyrantRuby < Tokyocabinet
  @url= "#{Tokyocabinet.url_base}/tyrantrubypkg/tokyotyrant-ruby-1.12.tar.gz"
  @md5='e8b5daafaeba5714468462ce9752f372'
  @version = "1.12"
  
  def dep
    LibraryDep.new 'tokyotyrant'
  end
  
  def install tyrant_prefix=nil
    # i know Sudo isn't cool, but I'm not ready to have my ruby co-mingling yet.
    system "ruby install.rb"
  end
  
  def cavats
    "This will likely install into your default ruby install. You may need to use sudo to install."
  end
end
