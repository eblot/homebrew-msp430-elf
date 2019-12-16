class CcTool < Formula
  desc "Support for Texas Instruments CC Debugger."
  homepage "https://sourceforge.net/projects/cctool"
  head "https://github.com/dashesy/cc-tool.git"

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libusb"

  def install
    pkgconfig = Formulary.factory 'pkg-config'

    ENV['PKG_CONFIG'] = "#{pkgconfig.opt_prefix}/bin/pkg-config"

    system "autoreconf -i"
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make", "install"
  end
end
