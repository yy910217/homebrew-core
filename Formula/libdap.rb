class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.4.tar.gz"
  sha256 "b16812c6ea3b01e5a02a54285af94a7dd57db929a6e92b964d642534f48b8474"
  revision 1

  bottle do
    sha256 "264911ff0609114fb283ff064eae32fca1cb652d4e51c38ba14bdeab20a358fe" => :mojave
    sha256 "d3b7cad46e5ece64f04065bb47fe27528ec1c3845588a0ddb3d8c50fb29948ad" => :high_sierra
    sha256 "33da2c630d4bd6eba319e3cfafc4e9095bb8f236bd65f14a845ff797f3fe140b" => :sierra
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
