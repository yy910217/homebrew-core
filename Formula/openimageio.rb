class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-2.0.9.tar.gz"
  sha256 "0cc7f8db831482ada4f7c7f97859eb4db6b0fc3626100f94a89053da1e1a8615"
  revision 3
  head "https://github.com/OpenImageIO/oiio.git"

  bottle do
    sha256 "341902d617619b41cb36c277e0442d3a0df44a8c6e36f2fbc48449df92ae5c93" => :mojave
    sha256 "0f4484a3b827dc8ba409327a9c27740bcc25ec36249477ea50dcbc34470198fd" => :high_sierra
    sha256 "8d83a37d48c11285be9556af8882625350f51f2dc98ffbdebb45e85b12c6f755" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "python"
  depends_on "webp"

  def install
    args = std_cmake_args + %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python dylib, even if we have a brewed one.
    py3ver = Language::Python.major_minor_version "python3"
    py3prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{py3ver}"

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/libpython#{py3ver}.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}m"

    # CMake picks up boost-python instead of boost-python3
    args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    args << "-DBoost_PYTHON_LIBRARIES=#{Formula["boost-python3"].opt_lib}/libboost_python#{py3ver.to_s.delete(".")}-mt.dylib"

    # This is strange, but must be set to make the hack above work
    args << "-DBoost_PYTHON_LIBRARY_DEBUG=''"
    args << "-DBoost_PYTHON_LIBRARY_RELEASE=''"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.to_s, pipe_output("python3", output, 0)
  end
end
