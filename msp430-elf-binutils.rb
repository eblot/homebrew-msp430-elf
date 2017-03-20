require 'formula'

class Msp430ElfBinutils <Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/'
  sha256 '6297433ee120b11b4b0a1c8f3512d7d73501753142ab9e2daa13c5a3edd32a72'

  keg_only :versioned_formula

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
