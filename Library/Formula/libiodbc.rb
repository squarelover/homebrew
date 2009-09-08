require 'brewkit'

class Libiodbc <Formula
  @url='http://www.iodbc.org/downloads/iODBC/libiodbc-3.52.6.tar.gz'
  @homepage='http://www.iodbc.org/'
  @md5='761ad547467bd63ac0b2b4f3ee4b5afb'
  @version='3.52.6'


  def install
    configure_flags = [
      "--prefix=#{prefix}", 
      "--disable-debug", 
      "--disable-dependency-tracking",
      "--disable-gui",
      "--enable-pthreads",
      "--enable-shared",
      "--enable-static",
      "--with-iodbc-inidir=/Library/ODBC" 
    ]
    system "./configure", *configure_flags
    system "make"
    system "make install"
  end
end
