require 'brewkit'

# XXX have to set PY_PREFIX to the "prefix part" of the python binary
# location, to support virtualenvs. Might be a better way to do this.
#
# TODO Fix java support anyone?
#
#
#
EXTRA_ENV = ""
MACOSX_DEPLOYMENT_TARGET = ENV["MACOSX_DEPLOYMENT_TARGET"]
if MACOSX_DEPLOYMENT_TARGET
    EXTRA_ENV = "MACOSX_DEPLOYMENT_TARGET=#{MACOSX_DEPLOYMENT_TARGET}"
end

PYTHON_GET_PREFIX = '
import sys
print(sys.executable.split("/bin")[0])
'

PATCH1='
--- /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 14:36:45.000000000 -0800
+++ /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 16:41:30.000000000 -0800
@@ -270,7 +270,7 @@
 
   Thread::id_t getCurrentThreadId() const {
     // TODO(dreiss): Stop using C-style casts.
-    return (id_t)pthread_self();
+    return (Thread::id_t)pthread_self();
   }
 
 };
'

class Thrift <Formula
  @homepage='http://incubator.apache.org/thrift/'
  @head='http://svn.apache.org/repos/asf/incubator/thrift/trunk'

  def download_strategy
      SubversionDownloadStrategy
  end

  def pyprefix
    `python -c '#{PYTHON_GET_PREFIX}'`.strip()
  end

  def env
      "env PY_PREFIX=#{pyprefix} #{EXTRA_ENV}"
  end

  def install
    system "cp /usr/X11/share/aclocal/pkg.m4 aclocal"
    system "echo '#{PATCH1}' | patch -p1"
    system "#{env} bash bootstrap.sh"
    system "#{env} ./configure --without-java --prefix='#{prefix}' --libdir='#{lib}'"
    system "#{env} make"
    system "#{env} make install"
  end
end
