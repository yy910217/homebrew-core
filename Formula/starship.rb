class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.18.0.tar.gz"
  sha256 "6792e7359577eca6f858559ebbee80dee4ccb97039973f8ba6f14a05c6e38c13"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17936b2c1610430561df172f30f77f9493846d308aa2020a88b94040a8764f75" => :mojave
    sha256 "67683344183160625b1fdf8081480167bce5c9fa1bd8a080fe81d331290e9325" => :high_sierra
    sha256 "4bf6d62c4c292a07bb30e228c04d43acf38903ea1a4475b42b74390e7b9f336c" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
