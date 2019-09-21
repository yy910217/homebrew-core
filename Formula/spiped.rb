class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.0.tgz"
  sha256 "e6f7f8f912172c3ad55638af8346ae7c4ecaa92aed6d3fb60f2bda4359cba1e4"
  revision 1

  bottle do
    cellar :any
    sha256 "3b395a73b22765da7859db5c5bb39291b6e748b29d52174be4944dedecf8e5f2" => :mojave
    sha256 "dfe6aac663c1f2196eb20aa617e576bdec5775a8426d0860848be734a9b2b86d" => :high_sierra
    sha256 "39af54b67bbd4b6dd9d35bcd7d6a36cef8e9ebc936116ca60ab189f0a2127b4b" => :sierra
  end

  depends_on "bsdmake" => :build
  depends_on "openssl@1.1"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
