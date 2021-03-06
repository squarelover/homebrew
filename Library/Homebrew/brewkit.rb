#  Copyright 2009 Max Howell and other contributors.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
require 'osx/cocoa' # to get number of cores
require 'formula'
require 'download_strategy'
require 'hw.model'

ENV['MACOSX_DEPLOYMENT_TARGET']='10.5'
ENV['CFLAGS']='-O3 -w -pipe -fomit-frame-pointer -mmacosx-version-min=10.5'
ENV['LDFLAGS']='' # to be consistent, we ignore the environment usually already

# optimise all the way to eleven, references:
# http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
# http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
# http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/i386-and-x86_002d64-Options.html
case hw_model
  when :core1
    # Core DUO is a 32 bit chip
    ENV['CFLAGS']="#{ENV['CFLAGS']} -march=prescott -mfpmath=sse -msse3 -mmmx"
  when :core2
    # Core 2 DUO is a 64 bit chip
    # GCC 4.3 will have a -march=core2, but for now nocona is correct
    ENV['CFLAGS']="#{ENV['CFLAGS']} -march=nocona -mfpmath=sse -msse3 -mmmx"
    
    # OK so we're not doing 64 bit yet... but we will with Snow Leopard
    # -mfpmath=sse defaults to on for the x64 compiler
    #ENV['CFLAGS']="#{ENV['CFLAGS']} -march=nocona -msse3 -mmmx -m64"
    #ENV['LDFLAGS']="-arch x86_64"

  when :xeon
    # TODO what optimisations for xeon?

  when :ppc   then abort "Sorry, Homebrew does not support PowerPC architectures"
  when :dunno then abort "Sorry, Homebrew cannot determine what kind of Mac this is!"
end

ENV['CXXFLAGS']=ENV['CFLAGS']

# lets use gcc 4.2, it is newer and "better", at least I believe so, mail me
# if I'm wrong
ENV['CC']='gcc-4.2'
ENV['CXX']='g++-4.2'
ENV['MAKEFLAGS']="-j#{OSX::NSProcessInfo.processInfo.processorCount}"


unless HOMEBREW_PREFIX.to_s == '/usr/local'
  ENV['CPPFLAGS']="-I#{HOMEBREW_PREFIX}/include"
  ENV['LDFLAGS']="-L#{HOMEBREW_PREFIX}/lib"
end


# you can use these functions for packages that have build issues
module HomebrewEnvExtension
  def deparallelize
    remove 'MAKEFLAGS', /-j\d+/
  end
  def gcc_4_0_1
    self['CC']=nil
    self['CXX']=nil
  end
  def osx_10_4
    self['MACOSX_DEPLOYMENT_TARGET']=nil
    remove_from_cflags(/ ?-mmacosx-version-min=10\.\d/)
  end
  def generic_i386
     %w[-mfpmath=sse -msse3 -mmmx -march=\w+].each {|s| remove_from_cflags s}
  end
  def libxml2
    self['CXXFLAGS']=self['CFLAGS']+=' -I/usr/include/libxml2'
  end
  def libpng
    append 'CPPFLAGS', '-I/usr/X11R6/include'
    append 'LDFLAGS', '-L/usr/X11R6/lib'
  end
  # we've seen some packages fail to build when warnings are disabled!
  def enable_warnings
    remove_from_cflags '-w'
  end
  
private
  def append key, value
    ref=self[key]
    if ref.nil? or ref.empty?
      self[key]=value
    else
      self[key]=ref+' '+value
    end
  end
  def remove key, rx
    return if self[key].nil?
    # sub! doesn't work as "the string is frozen"
    self[key]=self[key].sub rx, ''
    self[key]=nil if self[key].empty? # keep things clean
  end
  def remove_from_cflags rx
    %w[CFLAGS CXXFLAGS].each {|key| remove key, rx}
  end
end

ENV.extend HomebrewEnvExtension

# remove MacPorts and Fink from the PATH, this prevents issues like:
# http://github.com/mxcl/homebrew/issues/#issue/13
paths=ENV['PATH'].split(':').reject do |p|
  p.squeeze! '/'
  p=~%r[^/opt/local] or p=~%r[^/sw]
end
ENV['PATH']=paths*':'


def inreplace(path, before, after)
  before=Regexp.escape before.to_s
  before.gsub! "/", "\\/" # I guess not escaped as delimiter varies
  after=after.to_s
  after.gsub! "\\", "\\\\"
  after.gsub! "/", "\\/"

  # TODO this sucks
  # either use 'ed', or allow regexp and use a proper ruby function
  safe_system "perl", "-pi", "-e", "s/#{before}/#{after}/g", path
end
