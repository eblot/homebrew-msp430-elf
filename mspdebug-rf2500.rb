class MspdebugRf2500 < Formula
  desc "MSPDebug is a free debugger for use with MSP430 MCUs."
  homepage "https://github.com/eblot/mspdebug"
  head "https://github.com/eblot/mspdebug.git", :branch => "rf2500_hidapi"

  depends_on "hidapi"

  def install
    inreplace "Makefile", "-I/opt/local/include", "-I#{Formulary.factory('hidapi').prefix}/include/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
