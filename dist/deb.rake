file pkg("/kidsruby-#{version}.deb") => distribution_files do |t|
  mkchdir(File.dirname(t.name)) do
    mkchdir("usr/local/kidsruby") do
      assemble_distribution
      assemble resource("deb/kidsruby"), "bin/kidsruby", 0755
    end
    mkchdir("usr/share") do
      assemble resource("deb/kidsruby.desktop"), "applications/kidsruby.desktop"
      assemble resource("deb/kidsrubylogo.png"), "pixmaps/kidsrubylogo.png"
    end

    sh "tar czvf data.tar.gz usr/local/kidsruby usr/share/"

    assemble resource("deb/control"), "control"
    assemble resource("deb/postinst"), "postinst"

    sh "tar czvf control.tar.gz control postinst"

    File.open("debian-binary", "w") do |f|
      f.puts "2.0"
    end

    deb = File.basename(t.name)

    sh "ar -r #{t.name} debian-binary control.tar.gz data.tar.gz"
  end
end

namespace :deb do
  task :make do
    Rake::Task['deb:clone'].invoke
    Rake::Task['deb:build'].invoke
    Rake::Task['deb:copy'].invoke
    Rake::Task['deb:clean'].invoke
  end

  desc "Clone into kidsruby rep"
  task :clone do
    fetch_current 
  end
  
  desc "Build a .deb package"
  task :build  => pkg("/kidsruby-#{version}.deb")

  desc "Copy .deb package into project root directory"
  task :copy do
   FileUtils.copy(pkg("/kidsruby-#{version}.deb"),"kidsruby-#{version}.deb") 
  end

  desc "Remove build artifacts for .deb"
  task :clean do
    FileUtils.rm_rf("pkg/") if Dir.exists?("pkg/")
    FileUtils.rm_rf("tmp/") if Dir.exists?("tmp/")
  end
end
