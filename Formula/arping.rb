class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.20.tar.gz"
  sha256 "2543d433d6047a208331749c39ac3b2e0c8a743e135435d61fd1665dc3e228d1"

  bottle do
    cellar :any
    sha256 "15e267fd6609e686236668578452b0d2f3fc7771b24fb9ef1486fe9752f44645" => :mojave
    sha256 "f9d6ddf4906c516e80b25f7a28e8d00f917af69653dc9ecfcc36a0f4bd0b2f99" => :high_sierra
    sha256 "3170e9a0f53d76b1ae18ae15fa5945578044debb5798c1955bb8d9437b83088e" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"
  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
