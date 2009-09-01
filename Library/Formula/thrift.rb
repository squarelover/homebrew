require 'brewkit'

PATCH="
--- /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 14:36:45.000000000 -0800
+++ /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 16:41:30.000000000 -0800
@@ -270,7 +270,7 @@
 
   Thread::id_t getCurrentThreadId() const {
     // TODO(dreiss): Stop using C-style casts.
-    return (id_t)pthread_self();
+    return (Thread::id_t)pthread_self();
   }
 
 };
"

class Thrift <Formula
  @homepage='http://incubator.apache.org/thrift/'
  @url='http://gitweb.thrift-rpc.org/?p=thrift.git;a=snapshot;h=HEAD;sf=tgz'
  @head="HEAD"
  @version=@head
  @dont_verify_integrity=true

  def install
    # we specify libdir too because the script is apparently broken
    system "tar xvfz '?p=thrift.git;a=snapshot;h=HEAD;sf=tgz'"
    Dir.chdir("thrift")
    system "cp /usr/X11/share/aclocal/pkg.m4 aclocal"
    system "echo '#{PATCH}' | patch -p1"
    system "bash bootstrap.sh"
    system "./configure --prefix='#{prefix}' --libdir='#{lib}'"
    system "make"
    system "make install"
  end
end
