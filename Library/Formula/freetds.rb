require 'brewkit'

class Freetds <Formula
  @url='http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/freetds-patched.tgz'
  @homepage='http://freetds.org'
  @md5='240f6c3eb354c2feb744bd984fc37cb3'
  @version="0.82.1"
  
  def deps
    if ARGV.include? '--with-unixodbc' or Formula.factory('unixodbc').installed?
      LibraryDep.new 'unixodbc'
    else
      LibraryDep.new 'libiodbc'
    end
  end

  def install
    
    inreplace "src/server/Makefile.in", "../replacements/libreplacements.la", ""
    inreplace "src/ctlib/Makefile.in", "../replacements/libreplacements.la", ""
    inreplace "src/odbc/Makefile.in",  "../replacements/libreplacements.la", ""
    inreplace "src/dblib/Makefile.in", "../replacements/libreplacements.la", ""
    inreplace "src/apps/Makefile.in", "../replacements/libreplacements.la", ""

    inreplace "src/apps/fisql/Makefile.in", "../../replacements/libreplacements.la", ""
    inreplace "src/dblib/unittests/Makefile.in", "../../replacements/libreplacements.la", ""
    inreplace "src/tds/unittests/Makefile.in",  "../../replacements/libreplacements.la", ""

    config_flags = [
      "--prefix=#{prefix}", 
      "--with-libiconv-prefix=/usr"
    ]

    if ARGV.include? '--with-unixodbc'
      odbc_prefix = Formula.factory('unixodbc').prefix
      config_flags << "--with-unixodbc=#{odbc_prefix}"
    else
      iodbc_prefix = Formula.factory('libiodbc').prefix
      config_flags << "--with-iodbc=#{iodbc_prefix}"
    end
    
    # Variant: mssql description {Use MS style dblib}
    if ARGV.include? '--with-mssql'
      config_flags.concat [ "--enable-msdblib",  "--with-tdsver=8.0" ]
    end
    ENV.deparallelize
    system "cp /usr/bin/glibtool libtool"  # this is needed for some reason.
    system "./configure", config_flags
    system "make"
    system "make install"
  end
  
  def caveats
    "On 64bit and/or Snow Leopard systems, intending to use Ruby, should install with the --with-unixodbc flag."
  end
end
