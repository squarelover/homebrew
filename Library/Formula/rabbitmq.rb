require 'brewkit'

class Rabbitmq <Formula
  @homepage='http://rabbitmq.com'
  @url='http://www.rabbitmq.com/releases/rabbitmq-server/v1.6.0/rabbitmq-server-1.6.0.tar.gz'
  @md5='af3b0d868d58e5aefb4f0837b82ca010'
  @version="1.6.0"

  def deps
      BinaryDep.new 'erlang'
  end

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

  def caveats
    "The output from the install phase of the make file will cause brew to believe the install failed if you use the --verbose flag."
  end
end
