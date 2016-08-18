require 'formula'

class Msp430ElfGdb <Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.xz'
  homepage 'https://www.gnu.org/software/gdb/'
  sha256 '7a434116cb630d77bb40776e8f5d3937bed11dea56bafebb4d2bc5dd389fe5c1'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'libmpc'

  def install
    system "./configure", "--prefix=#{prefix}", "--target=msp430-elf",
                "--with-gmp=#{Formula.factory('gmp').prefix}",
                "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                "--with-mpc=#{Formula.factory('libmpc').prefix}",
                "--without-cloog","--disable-werror"
    system "make"
    system "make install"
  end
end
