## Getting started

If you use `mise`, you can run `setup` directly, because `./bin` is added to `$PATH` via `mise.toml`.

Otherwise, you're stuck adding `./bin` before all the commands!

## Repo Overview

- `lib` : Ruby source

- `spec` : tests, `rspec`-based

- `tasks`: rake tasks

- `extras`: dir containing useful scripts, apps, and other items to help with development

## Notable `rake` tasks

- `dev:testapp`:
    - runs the rails testapp in the `spec/rails_test_app` directory

- `dev:host_capture`:
    - runs the rails testapp in "capture mode", which uses the `localhost` gem to enable https. You can use this to capture additional test data from devices on your local network, or just examine the output. SEE [this readme](./tasks/dev/README.md) for more information

- `dev:android_capture`:
    - runs a sequence of commands to run the testapp server in capture mode, install and run the android app from `extras`, then scrape the detection result from the server log. This is used to capture Android WebView headers from the test device. SEE [this readme](./tasks/dev/README.md) for more information

- `ci:test_report`:
    - reads the coverage and test result files generated via the github CI workflow and adds annotations and summary output

    