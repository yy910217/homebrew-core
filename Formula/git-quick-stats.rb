class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.0.9.tar.gz"
  sha256 "91515b0b324f82cd09e569b5c29c406c520344647480ec9d537c49f64235df33"

  bottle :unneeded

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match /^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1)
  end
end
