require 'brewkit'

class Unixodbc <Formula
  @url='http://www.unixodbc.org/unixODBC-2.2.14.tar.gz'
  @homepage='http://www.unixodbc.org/'
  @md5='f47c2efb28618ecf5f33319140a7acd0'
  @version='2.2.14'

# def deps
#   BinaryDep.new 'cmake'
# end

  def patches
    [
      "http://pastie.org/609213.txt",
      "http://pastie.org/609215.txt",
      "http://pastie.org/609217.txt"
    ]
  end
  
  def install
    system "./configure", "--prefix=#{prefix}", 
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--enable-static",
                          "--enable-shared",
                          "--enable-gui=no",
                          "--with-libiconv-prefix=/usr"
    system "make install"
  end
end
