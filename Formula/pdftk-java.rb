class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.7/pdftk-v3.0.7.tar.gz"
  sha256 "6f7cb547076c54d1c500a9ff35ba677859cbca4b7b4d73dc14d167f81c00407c"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8776628a6b3afc26c98ea2f2994f4e8ae03dfba301fd00244ddb490ea578eb58" => :mojave
    sha256 "359e90f7faa4d4b7c84cd469d42b3c9bf781d2d2c8c0005c7fad09772cf474a1" => :high_sierra
    sha256 "672d73b18df1bda469a87d257750986abed3fba44bd936e557940acc499be26a" => :sierra
  end

  depends_on "gradle" => :build
  depends_on :java => "1.7+"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk.jar"
    bin.write_jar_script libexec/"pdftk.jar", "pdftk", :java_version => "1.7+"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
