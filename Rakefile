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
  g = Git.clone("https://github.com/hybridgroup/kidsruby.git", 'tmp') 
  g.branch("v1.4.0").checkout
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
      system("echo gem \\'hybridgroup-sphero\\' >> #{project_root}/Gemfile")
      system("bundle install --without test development --path vendor")
    end
  end
  system("cd #{project_root}/vendor/ruby/1.9.1/gems/qtbindings-4.6.3.4/ && rm -rfv bin/ examples/ ext/")
end

def copy_dependencies 
  puts "Copying dependencies...."
  FileUtils.mkdir_p("#{project_root}/vendor/dependencies")
  dep = ["libQtCore.so.4", "libQtGui.so.4", "libQtSvg.so.4","libQtWebKit.so.4","libQtOpenGL.so.4","libopenal.so.1","libSDL_ttf-2.0.so.0","libQtNetwork.so.4","libQtDBus.so.4","libQtXml.so.4","libQtSql.so.4","libQtXmlPatterns.so.4","libfreeimage.so.3", "libaudio.so.2"]
  if architecture == 'armv6l'
    a = ["libIlmImf.so.6","libImath.so.6","libHalf.so.6","libIex.so.6","libIlmThread.so.6","libraw.so.5"]
  else
    a = ["libSDL-1.2.so.0","libdirect-1.2.so.9", "libfusion-1.2.so.9","libdirectfb-1.2.so.9","libphonon.so.4", "libIlmImf.so.6", "libopenjpeg.so.2", "libraw.so.5" ,"libHalf.so.6" ,"libIex.so.6" ,"libImath.so.6", "libIlmThread.so.6"]
  end
  dep = dep + a
  dep.each do |lib|
    f = `echo -n $(find /usr/lib -name #{lib})`
    FileUtils.cp("#{f}", "#{project_root}/vendor/dependencies/#{lib}", :verbose => true)
  end
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
  '1.4.0.1'
end
def installedsize
  `echo -n "$(du -s #{pkg_root}/usr | cut -f -1)"`.to_i
end
def architecture
  `echo -n "$(uname -m)"`
end
