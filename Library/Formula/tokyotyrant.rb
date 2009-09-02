require 'brewkit'
require File.expand_path(File.dirname(__FILE__)+'/tokyocabinet')

class Tokyotyrant < Tokyocabinet
  @url= "#{Tokyocabinet.url_base}/tyrantpkg/tokyotyrant-1.1.33.tar.gz"
  @homepage='http://tokyocabinet.sourceforge.net/'
  @md5='880d6af48458bc04b993bdae6ecc543d'
  
  def deps
    LibraryDep.new 'tokyocabinet'
    LibraryDep.new 'lua'
  end
  
  def configure_flags
    lua_dep_prefix = Formula.factory('lua').prefix
    super.concat ["--enable-lua", "--with-lua=#{lua_dep_prefix}"]
  end
  
  def ruby_libname
    "tokyotyrant_ruby"
  end 
end