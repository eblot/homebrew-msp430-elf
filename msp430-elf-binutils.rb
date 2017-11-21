require 'formula'

class Msp430ElfBinutils <Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/'
  sha256 '1509dff41369fb70aed23682351b663b56db894034773e6dbf7d5d6071fc55cc'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}", "--target=msp430-elf",
                "--disable-shared", "--disable-nls", "--enable-lto",
                "--with-gmp=#{Formulary.factory('gmp').prefix}",
                "--with-mpfr=#{Formulary.factory('mpfr').prefix}",
                "--disable-werror", "--disable-debug"
    system "make"
    system "make install"
  end
end
