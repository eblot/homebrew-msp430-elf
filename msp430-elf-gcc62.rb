require 'formula'

class Msp430ElfGcc62 <Formula
  homepage 'https://gcc.gnu.org'
  url      'http://ftpmirror.gnu.org/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2'
  mirror   'https://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2'
  sha256   '9944589fc722d3e66308c0ce5257788ebd7872982a718aa2516123940671b7c5'

  keg_only 'Enable installation of several GCC versions'

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'
  depends_on 'msp430-elf-binutils227'
  depends_on 'gcc6' => :build

  resource 'newlib24' do
    url    'ftp://sourceware.org/pub/newlib/newlib-2.4.0.tar.gz'
    sha256 '545b3d235e350d2c61491df8b9f775b1b972f191380db8f52ec0b1c829c52706'
  end

  resource 'mspdefs' do
    url    'http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/latest/exports/msp430-gcc-support-files-1.191.zip'
    # 'lastest' is unfortunately a very bad reference, as it could be updated at any time...
    sha256 '86ccab9bce91fc7e9192f2ab96b3b94b70bb626ba88b8bdc945266ef44dbb4f8'
  end

  def install

    msp430_bu = 'msp430-elf-binutils227'

    coredir = Dir.pwd

    resource('newlib24').stage do
      system 'ditto', Dir.pwd+'/libgloss', coredir+'/libgloss'
      system 'ditto', Dir.pwd+'/newlib', coredir+'/newlib'
    end

    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'
    libelf = Formula.factory 'libelf'
    binutils = Formula.factory msp430_bu
    gcc6 = Formula.factory 'gcc6'

    # Fix up CFLAGS for cross compilation (default switches cause build issues)
    ENV['CC'] = "#{gcc6.opt_prefix}/bin/gcc-6"
    ENV['CXX'] = "#{gcc6.opt_prefix}/bin/g++-6"
    ENV['CFLAGS_FOR_BUILD'] = "-O2"
    ENV['CFLAGS'] = "-O2"
    ENV['CFLAGS_FOR_TARGET'] = "-O2"
    ENV['CXXFLAGS_FOR_BUILD'] = "-O2"
    ENV['CXXFLAGS'] = "-O2"
    ENV['CXXFLAGS_FOR_TARGET'] = "-O2"

    # Do not build C++, whose configuration script seems borken with
    # libitm/size_t format detection
    build_dir='build'
    mkdir build_dir
    Dir.chdir build_dir do
      system coredir+"/configure", "--prefix=#{prefix}", "--target=msp430-elf",
                  "--with-gnu-as", "--with-gnu-ld",
                  "--with-newlib", "--disable-underscore",
                  "--disable-shared", "--enable-lto", "--enable-plugins",
                  "--enable-languages=c",
                  "--with-gmp=#{gmp.opt_prefix}",
                  "--with-mpfr=#{mpfr.opt_prefix}",
                  "--with-mpc=#{libmpc.opt_prefix}",
                  "--with-libelf=#{libelf.opt_prefix}",
                  "--disable-debug"
      system "make"
      system "make -j1 -k install"
      copy coredir+"/libgloss/libnosys/nosys.specs", "#{prefix}/msp430-elf/lib"
    end

    ln_s "#{Formula.factory(msp430_bu).prefix}/msp430-elf/bin",
                   "#{prefix}/msp430-elf/bin"

    resource('mspdefs').stage do
      mkdir_p "#{prefix}/msp430-elf/include"
      mkdir_p "#{prefix}/msp430-elf/lib"
      copy Dir.glob(Dir.pwd+'/include/*.h'), "#{prefix}/msp430-elf/include"
      copy Dir.glob(Dir.pwd+'/include/*.ld'), "#{prefix}/msp430-elf/lib"
    end

  end
end
