class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.72.0.tar.gz"
  sha256 "6d619613d6f5d25ddabd03a07629be0bfcd58bfeeb7314497dc04d1aeb7c6d67"
  revision 1
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8d963db3b50abc419b0541d5f707b97edb6c2df1cda7726968ede24eece287f" => :mojave
    sha256 "d8d963db3b50abc419b0541d5f707b97edb6c2df1cda7726968ede24eece287f" => :high_sierra
    sha256 "0a87821d6ce7c311fef0fb1de9c74f561a30aa51342318a466edda0be0da0b53" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "pygtk"
  depends_on "pygtksourceview"
  depends_on "python"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.7/site-packages"
    resource("pyxdg").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.7/site-packages"
    system "python3", "./setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"], :XDG_DATA_DIRS => libexec/"share"
    pkgshare.install "zim"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    system "#{bin}/zim", "--version"
  end
end
