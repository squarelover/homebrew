require 'brewkit'

class Couchdb <Formula
  @url='http://apache.multihomed.net/couchdb/0.9.1/apache-couchdb-0.9.1.tar.gz'
  @homepage='http://couchdb.apache.org/'
  @md5='9583efae5adfb3f9043e970fef825561'
  @version = "0.9.1"

  def deps
    BinaryDep.new 'erlang'
    LibraryDep.new 'spidermonkey'
    LibraryDep.new 'icu4c'
  end
  
  def install
    jslib_dep_prefix = Formula.factory('spidermonkey').prefix
    config_flags = ["--prefix=#{prefix}", 
                    "--with-js-include=#{jslib_dep_prefix}/include", 
                    "--with-js-lib=#{jslib_dep_prefix}/lib"]
    system "./configure", *config_flags
    system "make"
    system "make install"
  end
  
  def caveats
    <<-EOS
  ==============================================================
  If you wish to have CouchDB run at startup, you will need to do the following:

  1) If required, create a couchdb user and group

  2) Create a launchd item in /Library/LaunchDaemons/org.apache.couchdb.plist, like so:
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  	<key>EnvironmentVariables</key>
  	<dict>
  		<key>DYLD_LIBRARY_PATH</key>
  		<string>#{prefix}/lib:$DYLD_LIBRARY_PATH</string>
  		<key>HOME</key>
  		<string>~</string>
  		<key>PATH</key>
  		<string>/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin</string>
  	</dict>
  	<key>KeepAlive</key>
  	<true/>
  	<key>Label</key>
  	<string>org.apache.couchdb</string>
  	<key>OnDemand</key>
  	<true/>
  	<key>ProgramArguments</key>
  	<array>
  		<string>/usr/local/bin/couchdb</string>
  	</array>
  	<key>RunAtLoad</key>
  	<true/>
  	<key>StandardErrorPath</key>
  	<string>/dev/null</string>
  	<key>StandardOutPath</key>
  	<string>/dev/null</string>
  	<key>UserName</key>
  	<string>couchdb</string>
  </dict>
  </plist>

  3) Start the server using: sudo launchctl -w load /Library/LaunchDaemons/org.apache.couchdb.plist 
  ==============================================================
    EOS
  end
end
