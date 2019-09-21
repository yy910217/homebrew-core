class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz"
  sha256 "647c0ba4583d891c965fc29b77c4ccfeccc21f409fdf259cb8af52cb39c21e18"
  revision 1

  bottle do
    cellar :any
    sha256 "bd7d15750d00a4b75d6e8c0b2fe75a5e508c00ab832c206e4cf017d53c793c68" => :mojave
    sha256 "14e25d0a27df813595c6060767fb9e24545efe6065f6c15e2b27d3f5e704c449" => :high_sierra
    sha256 "4119699bb703aea5a3a9369300b209587209c4d8675d22997a16ed75089e141b" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "monitoring-plugins", :because => "monitoring-plugins ships their plugins to the same folder."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
