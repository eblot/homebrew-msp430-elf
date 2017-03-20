require 'formula'

class Msp430ElfGdb <Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.12.1.tar.xz'
  homepage 'https://www.gnu.org/software/gdb/'
  sha256 '4607680b973d3ec92c30ad029f1b7dbde3876869e6b3a117d8a7e90081113186'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'libmpc'

  def install
    system "./configure", "--prefix=#{prefix}", "--target=msp430-elf",
                "--with-gmp=#{Formulary.factory('gmp').prefix}",
                "--with-mpfr=#{Formulary.factory('mpfr').prefix}",
                "--with-mpc=#{Formulary.factory('libmpc').prefix}",
                "--without-cloog","--disable-werror"
    system "make"
    system "make install"
  end
end
