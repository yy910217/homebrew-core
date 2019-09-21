class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.3/libjpeg-turbo-2.0.3.tar.gz"
  sha256 "4246de500544d4ee408ee57048aa4aadc6f165fc17f141da87669f20ed3241b7"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 "dfc1db83aeb51510ee7fe2243d168f9a2a8898b65176f4c07282e2781cfdbbeb" => :mojave
    sha256 "ca326419069792b324e956a325190f0ad1425fc86174e36a5315d3781be6c41c" => :high_sierra
    sha256 "8b587585e4dd98b09ee49fbab70868d2874710506850ad7762f59c44a78c48fd" => :sierra
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
