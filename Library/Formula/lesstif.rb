require 'brewkit'

class Lesstif <Formula
  @url='http://prdownloads.sourceforge.net/lesstif/lesstif-0.95.2.tar.bz2?download'
  @homepage='http://lesstif.sourceforge.net/'
  @md5='754187dbac09fcf5d18296437e72a32f'
  @version='0.95.2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
