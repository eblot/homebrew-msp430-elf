require 'formula'

class Msp430ElfBinutils226 <Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.26.1.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/'
  sha256 '39c346c87aa4fb14b2f786560aec1d29411b6ec34dce3fe7309fe3dd56949fd8'

  keg_only 'Enable installation of several binutils versions'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}", "--target=msp430-elf",
                "--disable-shared", "--disable-nls", "--enable-lto",
                "--with-gmp=#{Formula.factory('gmp').prefix}",
                "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                "--disable-werror", "--disable-debug"
    system "make"
    system "make install"
  end
end
