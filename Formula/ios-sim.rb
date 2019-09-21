require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/8.0.2.tar.gz"
  sha256 "b5b95d9a68c0f93da393c97138ac287c651084a13444f76ce5670bded2c6fe78"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57eba6f175bb19ea53f53142345d6a729ff2494bf5e986182e19cd3228c13683" => :mojave
    sha256 "fb1aef7e85f401660584629d09499e3c58b788b11313dbf68fe0840ee372e20e" => :high_sierra
    sha256 "03387aef5b0f1f52d398971fd6189324f52f73b21bd4d1c378d516a50a329dce" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
