require 'brewkit'

class Tokyocabinet <Formula
  class << self
    def url_base
      "http://tokyocabinet.sourceforge.net"
    end
  end
  
  @url="#{url_base}/tokyocabinet-1.4.32.tar.gz"
  @homepage='http://tokyocabinet.sourceforge.net/'
  @md5='a1a161eab1cb7487b23b6c914e2afb3e'
  @version = "1.4.32"
  
  def ruby_libname
    "tokyocabinet_ruby"
  end
  
  def configure_flags 
    ["--prefix=#{prefix}", "--disable-debug"]
  end

  def install    
    system "./configure", *configure_flags
    system "make"
    system "make install"
    
    if ARGV.include? '--with-ruby' and ruby_libname
      Formula.factory(ruby_libname).brew do |f|
        f.install prefix
      end
    end
  end
end

