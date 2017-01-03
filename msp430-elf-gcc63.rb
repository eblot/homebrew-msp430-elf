require 'formula'

class Msp430ElfGcc63 <Formula
  homepage 'https://gcc.gnu.org'
  url      'http://ftpmirror.gnu.org/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2'
  mirror   'https://ftp.gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2'
  sha256   'f06ae7f3f790fbf0f018f6d40e844451e6bc3b7bc96e128e63b09825c1f8b29f'

  keg_only 'Enable installation of several GCC versions'

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'
  depends_on 'msp430-elf-binutils227'
  depends_on 'gcc6' => :build

  resource 'newlib25' do
    url    'ftp://sourceware.org/pub/newlib/newlib-2.5.0.tar.gz'
    sha256 '5b76a9b97c9464209772ed25ce55181a7bb144a66e5669aaec945aa64da3189b'
  end

  resource 'mspdefs' do
    url    'http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/latest/exports/msp430-gcc-support-files-1.194.zip'
    sha256 'b3c10470dbc0672b8deca2b60a376304d14a02837ef09b1b06810e89a6aa2d34'
  end

  def install

    msp430_bu = 'msp430-elf-binutils227'

    coredir = Dir.pwd

    resource('newlib25').stage do
      system 'ditto', Dir.pwd+'/libgloss', coredir+'/libgloss'
      system 'ditto', Dir.pwd+'/newlib', coredir+'/newlib'
    end

    # It would be better to install resources files once the compiler is built
    # however the lack of reliability of TI archive download often leads to 
    # sucessfully build a proper compiler but fails to complete the recipe 
    # because of a single missing resource. So try to retrieve the resource
    # first, build after...
    resource('mspdefs').stage do
      mkdir_p "#{prefix}/msp430-elf/include"
      mkdir_p "#{prefix}/msp430-elf/lib"
      copy Dir.glob(Dir.pwd+'/include/*.h'), "#{prefix}/msp430-elf/include"
      copy Dir.glob(Dir.pwd+'/include/*.ld'), "#{prefix}/msp430-elf/lib"
    end

    gmp = Formulary.factory 'gmp'
    mpfr = Formulary.factory 'mpfr'
    libmpc = Formulary.factory 'libmpc'
    libelf = Formulary.factory 'libelf'
    binutils = Formulary.factory msp430_bu
    gcc6 = Formulary.factory 'gcc6'

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

    ln_s "#{Formulary.factory(msp430_bu).prefix}/msp430-elf/bin",
         "#{prefix}/msp430-elf/bin"

  end
end
