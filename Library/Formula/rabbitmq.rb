require 'brewkit'

class Rabbitmq <Formula
  @homepage='http://rabbitmq.com'
  @url='http://www.rabbitmq.com/releases/rabbitmq-server/v1.6.0/rabbitmq-server-1.6.0.tar.gz'
  @md5='foobarbaz'
  @version="1.6.0"

  def erlang_libdir
    [HOMEBREW_PREFIX, "lib", "erlang", "lib"].join("/")
  end

  def homebrew_bindir
      [HOMEBREW_PREFIX, "bin"].join("/")
  end

  def install
    system "make"
    system "TARGET_DIR=#{erlang_libdir}/rabbitmq-#{version} \
                MAN_DIR=#{man}  \
                SBIN_DIR=#{sbin} \
                make install"
    system "ln -sf #{sbin}/* #{homebrew_bindir}/"
  end
end
