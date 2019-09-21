class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190822.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190822.tar.bz2"
  sha256 "77eaf5b58830c23e9607ced9e8a916ac4e17f40cfc86f224289df1e6505023d6"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "135d9358b6973501afd0e99f21975bc581c48b363bdda47c7046a068cecea5f5" => :mojave
    sha256 "135d9358b6973501afd0e99f21975bc581c48b363bdda47c7046a068cecea5f5" => :high_sierra
    sha256 "822abbf5e774573f03b31a844f2de1b79530e2f7bd98b12095f5d09f9f56c3b4" => :sierra
  end

  conflicts_with "moreutils",
    :because => "both install a `parallel` executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
