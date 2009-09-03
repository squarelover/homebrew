require 'brewkit'

class Openssl <Formula
  @url='http://www.openssl.org/source/openssl-1.0.0-beta3.tar.gz'
  @homepage='http://www.openssl.org'
  @md5='cf5a32016bb9da0b9578099727bf15c9'
  @version = "1.0.0-beta3"

  def install
    ENV.deparallelize
    system "./Configure", "darwin64-x86_64-cc", "shared", "zlib-dynamic", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
