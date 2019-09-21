require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.4.0/dhall-json-1.4.0.tar.gz"
  sha256 "31832fd8bdcf27ebea805143f62eb570970bf42cdd93cec73fdeb81c6a38ab4f"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9a6bc1b5598ecc0c1139e907a334751c99fa56ea2eea29cd6b8d32abc487e22" => :mojave
    sha256 "7bd58337a9afd282eae2cc13ed54b5a28f2f89f3a2bc58591835aed804a565f5" => :high_sierra
    sha256 "b1e13d14655544535611979e8f2d4ff543501a42fcf2c700e2cd73a1090c5874" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
