require 'brewkit'

class ErlangManuals <Formula
  @url='http://erlang.org/download/otp_doc_man_R13B01.tar.gz'
  @md5='fa8f96159bd9a88aa2fb9e4d79d7affe'
end

class ErlangHtmlDocs <Formula
  @url='http://erlang.org/download/otp_doc_html_R13B01.tar.gz'
  @md5='42cb55bbfa5dc071fd56034615072f7a'
end

class Erlang <Formula
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_src_R13B01.tar.gz'
  @md5='b3db581de6c13e1ec93d74e54a7b4231'
  
  def version
    "R13B01"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--prefix='#{prefix}'",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--enable-smp-support",
                          "--enable-hipe"
    system "make"
    system "make install"
  end
  
end