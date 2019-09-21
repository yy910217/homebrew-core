class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p13.tar.gz"
  version "4.2.8p13"
  sha256 "288772cecfcd9a53694ffab108d1825a31ba77f3a8466b0401baeca3bc232a38"
  revision 1

  bottle do
    cellar :any
    sha256 "88daac89608fccbee91081426b81aa0cf274df656d4f3bba9104c6622a2da070" => :mojave
    sha256 "25c4bb04713cbddea1e629a3e22994af48d04cbb89e3f91fe47533c343fa5ea9" => :high_sierra
    sha256 "c89c2be95d8c98771e28df90d361f1f969a3bc132ecad472d812ae31e6ebef91" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl-libdir=#{Formula["openssl@1.1"].lib}
      --with-openssl-incdir=#{Formula["openssl@1.1"].include}
      --with-net-snmp-config=no
    ]

    system "./configure", *args
    system "make", "install", "LDADD_LIBNTP=-lresolv -undefined dynamic_lookup"
  end

  test do
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
