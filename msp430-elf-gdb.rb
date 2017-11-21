require 'formula'

class Msp430ElfGdb <Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-8.0.1.tar.xz'
  homepage 'http://www.gnu.org/software/gdb/'
  sha256 '3dbd5f93e36ba2815ad0efab030dcd0c7b211d7b353a40a53f4c02d7d56295e3'

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
