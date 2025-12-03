namespace "dev" do
  testapp_path = File.expand_path("../../spec/rails_test_app", __dir__)

  def get_local_ip
    require "socket"

    addr_infos = Socket.ip_address_list
    addr_infos.find { |a| a.ipv4_private? }.ip_address
  end

  task "testapp" do
    sh "#{testapp_path}/bin/rails server"
  end

  task "testapp:stop" do
    pid_dir = File.expand_path("tmp/pids", testapp_path)
    files = Dir.children(pid_dir).filter { |f| f.end_with?(".pid") }
    pids = []
    files.each { |f| pids.push(File.read(File.join(pid_dir, f)).chomp) }

    pids.each { |pid| sh("kill -9 #{pid}") }
  end

  task "host_capture" do
    sh "CHCAPTURE=true ./spec/rails_test_app/bin/rails server"
  end

  task "android_capture" do
    require "open3"

    android_app_path = File.expand_path("../../extras/android_capture_app", __dir__)
    device = `ruby #{android_app_path}/app_commands.rb device`
    puts "Starting server"
    stdin, stdout_and_stderr, wait_thread = Open3.popen2e("CHCAPTURE=true ./spec/rails_test_app/bin/rails server")

    puts "Installing android app"
    `ruby #{android_app_path}/app_commands.rb -d #{device.chomp} install`
    puts yellow("Opening app, check device")
    ip = get_local_ip
    `ruby #{android_app_path}/app_commands.rb -d #{device.chomp} -u 'https://#{ip}:9292/client_hints/capture' open`
    puts yellow("Press [ENTER] when app shows capture page content...")
    $stdin.gets

    stdin.close
    stdout_and_stderr.close
    puts "Stopping server"
    `kill -9 #{wait_thread.pid}`

    log_file = File.new(File.join(testapp_path, "/log/development.log"))
    captured_lines = []

    log_file.each_line do |line|
      if line.include?('Started GET "/client_hints/capture"')
        if !captured_lines.empty?
          captured_lines = []
        end
        captured_lines.push line
      elsif !captured_lines.empty?
        captured_lines.push line
      end
    end
    log_file.close
    puts yellow("Server log below: \n\n")

    puts captured_lines

    puts yellow("Uninstalling app")
    `ruby #{android_app_path}/app_commands.rb -d #{device.chomp} uninstall`
  end
end
