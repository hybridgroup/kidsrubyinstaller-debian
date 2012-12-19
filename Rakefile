require "erb"
require "fileutils"
require "tmpdir"
require 'git'
require 'bundler'

Dir[File.expand_path("../dist/**/*.rake", __FILE__)].each do |rake|
  import rake
end

def fetch_current
  puts 'Cloning kidsruby...'
  Git.clone("https://github.com/hybridgroup/kidsruby.git", 'tmp') 
end

def compile_ruby
  puts 'Compiling ruby...'
  FileUtils.mkdir_p('ruby_tmp')
  Dir.chdir('ruby_tmp') do
    system("wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p320.tar.gz && tar -xzvf ruby-1.9.2-p320.tar.gz")
    Dir.chdir('ruby-1.9.2-p320') do
      system("./configure --prefix=/usr/local/kidsruby/ruby --enable-shared --disable-install-doc && make && make install DESTDIR=#{pkg_root}")
    end
  end
end

def install_gems
  puts 'Bundling gems...'
  Dir.chdir(project_root) do
    Bundler.with_clean_env do
      system("echo gem \\'gosu\\' >> #{project_root}/Gemfile")
      system("bundle install --without test development --path vendor")
    end
  end
end

def copy_dependencies 
  puts "Copying dependencies...."
  FileUtils.mkdir_p("#{project_root}/vendor/dependencies")
  if architecture == 'armv6l'
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtWebKit.so.4", "#{project_root}/vendor/dependencies/libQtWebKit.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtOpenGL.so.4", "#{project_root}/vendor/dependencies/libQtOpenGL.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libopenal.so.1", "#{project_root}/vendor/dependencies/libopenal.so.1", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libSDL_ttf-2.0.so.0", "#{project_root}/vendor/dependencies/libSDL_ttf-2.0.so.0", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtNetwork.so.4", "#{project_root}/vendor/dependencies/libQtNetwork.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtDBus.so.4", "#{project_root}/vendor/dependencies/libQtDBus.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtXml.so.4", "#{project_root}/vendor/dependencies/libQtXml.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libQtSql.so.4", "#{project_root}/vendor/dependencies/libQtSql.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libIlmImf.so.6", "#{project_root}/vendor/dependencies/libIlmImf.so.6", :verbose => true)
    FileUtils.cp("/usr/lib/libImath.so.6", "#{project_root}/vendor/dependencies/libImath.so.6", :verbose => true)
    FileUtils.cp("/usr/lib/libHalf.so.6", "#{project_root}/vendor/dependencies/libHalf.so.6", :verbose => true)
    FileUtils.cp("/usr/lib/libIex.so.6", "#{project_root}/vendor/dependencies/libIex.so.6", :verbose => true)
    FileUtils.cp("/usr/lib/libIlmThread.so.6", "#{project_root}/vendor/dependencies/libIlmThread.so.6", :verbose => true)
    FileUtils.cp("/usr/lib/arm-linux-gnueabihf/libraw.so.5", "#{project_root}/vendor/dependencies/libraw.so.5", :verbose => true)
  else
    FileUtils.cp("/usr/lib/libopenal.so.1", "#{project_root}/vendor/dependencies/libopenal.so.1", :verbose => true)
    FileUtils.cp("/usr/lib/libQtWebKit.so.4", "#{project_root}/vendor/dependencies/libQtWebKit.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libQtOpenGL.so.4", "#{project_root}/vendor/dependencies/libQtOpenGL.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libQtCore.so.4", "#{project_root}/vendor/dependencies/libQtCore.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libQtGui.so.4", "#{project_root}/vendor/dependencies/libQtGui.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libQtNetwork.so.4", "#{project_root}/vendor/dependencies/libQtNetwork.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libQtSvg.so.4", "#{project_root}/vendor/dependencies/libQtSvg.so.4", :verbose => true)
    FileUtils.cp("/usr/lib/libSDL_ttf-2.0.so.0", "#{project_root}/vendor/dependencies/libSDL_ttf-2.0.so.0", :verbose => true)
    FileUtils.cp("/usr/lib/libSDL-1.2.so.0", "#{project_root}/vendor/dependencies/libSDL-1.2.so.0", :verbose => true)
    FileUtils.cp("/usr/lib/libdirect-1.2.so.0", "#{project_root}/vendor/dependencies/libdirect-1.2.so.0", :verbose => true)
    FileUtils.cp("/usr/lib/libfusion-1.2.so.0", "#{project_root}/vendor/dependencies/libfusion-1.2.so.0", :verbose => true)
    FileUtils.cp("/usr/lib/libdirectfb-1.2.so.0", "#{project_root}/vendor/dependencies/libdirectfb-1.2.so.0", :verbose => true)
  end
  FileUtils.cp("/usr/lib/libfreeimage.so.3", "#{project_root}/vendor/dependencies/libfreeimage.so.3", :verbose => true)
end

def assemble(source, target, perms=0644)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w") do |f|
    f.puts File.read(source)
  end
  File.chmod(perms, target)
end
def assemble_erb(source, target, perms=0644)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w") do |f|
    f.puts ERB.new(File.read(source)).result(binding)
  end
  File.chmod(perms, target)
end

def assemble_distribution(target_dir=Dir.pwd)
  distribution_files.each do |source|
    target = source.gsub(/^#{project_root}/, target_dir) 
    FileUtils.mkdir_p(File.dirname(target))
    FileUtils.cp(source, target)
  end
end

def clean(file)
  rm file if File.exists?(file)
end

def distribution_files
  except = Dir[File.expand_path("../tmp/{.bundle,dist,spec}/**/*", __FILE__)].select do |file|
    File.file?(file)
  end
  except.concat(Dir[File.expand_path("../tmp/Rakefile", __FILE__)])
  files - except
end

def files
  Dir[File.expand_path("../tmp/**/*", __FILE__)].select do |file|
    File.file?(file)
  end
end

def mkchdir(dir)
  FileUtils.mkdir_p(dir)
  Dir.chdir(dir) do |dir|
    yield(File.expand_path(dir))
  end
end

def pkg(filename)
  FileUtils.mkdir_p("pkg")
  File.expand_path("../pkg/#{filename}", __FILE__)
end

def project_root
  File.dirname(__FILE__)+"/tmp"
end
def pkg_root 
  File.dirname(__FILE__)+"/pkg"
end

def resource(name)
  File.expand_path("../dist/resources/#{name}", __FILE__)
end
def version
#  require File.expand_path("../tmp/app/models/version", __FILE__)
#  KidsRuby::VERSION
  '1.2'
end
def installedsize
  `echo -n "$(du -s #{pkg_root} | cut -f -1)"`.to_i
end
def architecture
  `echo -n "$(uname -m)"`
end
