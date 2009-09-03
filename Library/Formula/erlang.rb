require 'brewkit'

class ErlangManuals <Formula
  @version='R13B01'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_doc_man_R13B01.tar.gz'
  @md5='fa8f96159bd9a88aa2fb9e4d79d7affe'
end

class ErlangHtmlDocs <Formula
  @version='R13B01'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_doc_html_R13B01.tar.gz'
  @md5='42cb55bbfa5dc071fd56034615072f7a'
end

class Erlang <Formula
  @version='R13B01'
  @homepage='http://www.erlang.org'
  @url='http://erlang.org/download/otp_src_R13B01.tar.gz'
  @md5='b3db581de6c13e1ec93d74e54a7b4231'

  def deps
    LibraryDep.new 'icu4c'
    LibraryDep.new 'openssl'
  end
    
  def install
    ENV.deparallelize
    # erlang needs to build clean on Snow Leopard
    ENV['CFLAGS']=ENV['CXXFLAGS']=ENV['LDFLAGS']=""
    openssl_prefix = Formula.factory('openssl').prefix
    config_flags = ["--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-kernel-poll",
                          "--enable-threads",
                          "--enable-dynamic-ssl-lib",
                          "--with-ssl=#{openssl_prefix}",
                          "--enable-smp-support",
                          "--enable-hipe"]
    config_flags << "--enable-darwin-64bit" if hw_model == :core2 and os_version == :snow_leopard
    system "./configure", *config_flags
    system "make"
    system "make install"
    
    if ARGV.include? '--with-mandocs'
      ErlangManuals.new.brew { man.install Dir['man/*'] }
    end
  end
end