class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_10.3.orig.tar.gz"
  sha256 "86bd45e7e12d1bc8772c3cdd394e68a9feccb2a6d14aaf7dae0773b7274368ef"

  bottle do
    sha256 "0237851e478bcb76567111f14c1e42fe79161a8cd28ca04127295fc40db14113" => :mojave
    sha256 "96a15af23212d29f9410e073418c9388447955245fa8c38cf3b27ccf8fabd178" => :high_sierra
    sha256 "ded40d14a1cd74f2b764d9cf667d48ee8b6c010e77d88ca47afc99188ace1255" => :sierra
  end

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install", "BISON=#{Formula["bison"].opt_bin}/bison"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp

    # test syntax errors do not cause segfaults
    (testpath/"error.v").write "error;"
    assert_equal "-:1: error: variable declarations must be contained within a module.",
      shell_output("#{bin}/iverilog error.v 2>&1", 1).chomp
  end
end
