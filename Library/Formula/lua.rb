require 'brewkit'

class Lua <Formula
  @url='http://www.lua.org/ftp/lua-5.1.4.tar.gz'
  @homepage=''
  @md5='d0870f2de55d59c1c8419f36e8fac150'

  def install
    system "sed 's_/usr/local_#{prefix}_' < Makefile | sed 's_/man/man1_/share/man/man1_' > Makefile.new"
    FileUtils.mv 'Makefile', 'Makefile.old'
    FileUtils.mv 'Makefile.new', 'Makefile'
    system "make macosx"
    system "make install"
  end
end
