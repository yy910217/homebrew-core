class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag      => "v0.720",
      :revision => "36aecdae92d050f626ea9029ad08f0c8382c47e7"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e89cb9fc9273e033c83c89bf525793c3cfca6b950f2f66336a5544e57bc25eb" => :mojave
    sha256 "5890fbc8dc83dd5813475edba6cd5d627a9baa5093a0aec11bfc5f0048cec9c3" => :high_sierra
    sha256 "c789fe7ef362aa2d1cd92272bde151b49a3d78b30455fb472906a7ffa7b39d71" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1c/ca/5b8c1fe032a458c2c4bcbe509d1401dca9dda35c7fc46b36bb81c2834740/psutil-5.6.3.tar.gz"
    sha256 "863a85c1c0a5103a12c05a35e59d336e1d665747e531256e061213e2e90f63f3"
  end

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/ed/73/7e550d6e4cf9f78a0e0b60b9d93dba295389c3d271c034bf2ea3463a79f9/sphinx_rtd_theme-0.4.3.tar.gz"
    sha256 "728607e34d60456d736cc7991fd236afb828b21b82f956c5ea75f94c8414040a"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/34/de/d0cfe2ea7ddfd8b2b8374ed2e04eeb08b6ee6e1e84081d151341bba596e5/typed_ast-1.4.0.tar.gz"
    sha256 "66480f95b8167c9c5c5c87f32cf437d585937970f3fc24386f313a4c97b44e34"
  end

  resource "mypy_extensions" do
    url "https://files.pythonhosted.org/packages/c2/92/3cc05d1206237d54db7b2565a58080a909445330b4f90a6436302a49f0f8/mypy_extensions-0.4.1.tar.gz"
    sha256 "37e0e956f41369209a3d5f34580150bcacfabaa57b33a15c0b25f4b5725e0812"
  end

  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/59/b6/21774b993eec6e797fbc49e53830df823b69a3cb62f94d36dfb497a0b65a/typing_extensions-3.7.4.tar.gz"
    sha256 "2ed632b30bb54fc3941c382decfd0ee4148f5c591651c9272473fea2c6397d95"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    # https://github.com/python/mypy/issues/2593
    version_static = buildpath/"mypy/version_static.py"
    version_static.write "__version__ = '#{version}'\n"
    inreplace "docs/source/conf.py", "mypy.version", "mypy.version_static"

    (buildpath/"docs/sphinx_rtd_theme").install resource("sphinx_rtd_theme")
    # Inject sphinx_rtd_theme's path into sys.path
    inreplace "docs/source/conf.py",
              "sys.path.insert(0, os.path.abspath('../..'))",
              "sys.path[:0] = [os.path.abspath('../..'), os.path.abspath('../sphinx_rtd_theme')]"
    system "make", "-C", "docs", "html"
    doc.install Dir["docs/build/html/*"]

    rm version_static

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output
  end
end
