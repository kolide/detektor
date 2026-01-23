#! ruby
require "optparse"
require "open3"

ANDROID_PROJECT = File.join(__dir__, "MyApplication")
APK_PACKAGE_NAME = "com.kolide.mobile.chcapture.app"

OPTIONS = {}

build = OptionParser.new

install = OptionParser.new do |opts|
  opts.on("-d", "--device id") { |v| OPTIONS[:device] = v }
end

uninstall = OptionParser.new do |opts|
  opts.on("-d", "--device id") { |v| OPTIONS[:device] = v }
end

choose_device = OptionParser.new

open = OptionParser.new do |opts|
  opts.on("-d", "--device id") { |v| OPTIONS[:device] = v }
  opts.on("-u", "--url url") { |v| OPTIONS[:url] = v }
end

cmds = {
  "build" => build,
  "install" => install,
  "uninstall" => uninstall,
  "device" => choose_device,
  "open" => open
}

to_exec = []
ARGV.each do |arg|
  if cmds[arg]
    to_exec.push(arg)
    cmds[arg].parse!
  end
end

if to_exec.empty?
  throw "no executable cmd"
end

def do_cmd(cmd)
  stdout, stderr, status = Open3.capture3(cmd)
  puts stdout
  if !status.success?
    puts stderr
  end
end

def adb_cmd(device, cmd)
  device_selection = "-s #{device} " unless device.nil?
  "adb #{device_selection}#{cmd}"
end

def choose_adb_device
  devices = `adb devices`
  lines = devices.lines.drop(1).map(&:chomp).filter { |l| l.size > 1 }.to_a
  answer = 0
  if lines.size > 1
    puts "More than one adb device\n"
    lines.each_index { |i| puts "[#{i}] #{lines[i]}" }
    puts "Select one:"
    answer = gets.chomp.to_i
  elsif lines.size < 1
    throw "No adb devices, start an emulator or connect a usb device with debugging on"
  end
  result = lines[answer].split(" ")[0]
  puts result
  result
end

def build_app
  Dir.chdir(ANDROID_PROJECT)
  do_cmd("./gradlew assembleDebug copyApk")
  Dir.chdir("..")
end

def install_app
  apk_name = Dir.children(__dir__).find { |f| f.end_with?(".apk") }
  unless apk_name
    throw "No apk here in #{__dir__}, did you build?"
  end
  device = OPTIONS[:device] || choose_adb_device
  do_cmd(adb_cmd(device, "install -t #{File.join(__dir__, apk_name)}"))
end

def uninstall_app
  device = OPTIONS[:device] || choose_adb_device
  do_cmd(adb_cmd(device, "uninstall #{APK_PACKAGE_NAME}"))
end

def open_app
  device = OPTIONS[:device] || choose_adb_device

  data = "-d #{OPTIONS[:url]}" if OPTIONS[:url]

  do_cmd(adb_cmd(device, "shell am start -n #{APK_PACKAGE_NAME}/.MainActivity #{data}"))
end

if to_exec.include?("device")
  OPTIONS[:device] = choose_adb_device
end

if to_exec.include?("build")
  build_app
end

if to_exec.include?("install")
  install_app
end

if to_exec.include?("open")
  open_app
end

if to_exec.include?("uninstall")
  uninstall_app
end
