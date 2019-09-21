class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.2.1.tar.bz2"
  sha256 "8f9741399b4b184ba28698c0fd7722638e79abac8e6c27eb526cc52b11ee0a1c"

  bottle do
    sha256 "e23f9ab2a5d2a9f0108a1eeba61cd542246b67844c46903e06a9e86f9f313e0c" => :mojave
    sha256 "9dc50c35f361f19ef319025b6c2f61fab1d6346a7d6c5b3aa9b4416cb74fbecc" => :high_sierra
    sha256 "78d019f55f31bce34d607ce9f53dd45302d5e13163c28a5bab8ab02cd365d1a0" => :sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
