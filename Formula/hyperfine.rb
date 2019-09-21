class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.7.0.tar.gz"
  sha256 "d936aab473775e76c3a749828054e3f7d42e3909e8b0f56f99ecf6aa169a9bd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e594b60a9a42d58a48d257b4a3bfa9749ee49411109a8e0eadd1518e8765c46" => :mojave
    sha256 "3800230a38043d4e39d6e256c51ad8993d473e0c43aac1831278516c072b1f02" => :high_sierra
    sha256 "178a014e8792930ccf1114f035188e8a894c3688356257178e4bcec1dd008e49" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
