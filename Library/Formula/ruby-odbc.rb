require 'brewkit'

class RubyOdbc <Formula
  @url='http://www.ch-werner.de/rubyodbc/ruby-odbc-0.9997.tar.gz'
  @homepage='http://www.ch-werner.de/rubyodbc'
  @md5='36d21519795c3edc8bc63b1ec6682b99'
  @version='0.9997'

  def deps
    LibraryDep.new 'unixodbc'
  end

  def install
    odbc_prefix = Formula.factory('unixodbc').prefix
    system "CFLAGS=\"#{ENV['CFLAGS']}\" ruby extconf.rb --with-odbc-include=#{odbc_prefix}/include --with-odbc-lib=#{odbc_prefix}/lib"
    system "make"
    system "make install"
  end
end
