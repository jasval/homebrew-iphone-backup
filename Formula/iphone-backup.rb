class IphoneBackup < Formula
  desc "Automated iPhone/iPad backup manager with a Ratatui TUI, scheduled via launchd"
  homepage "https://github.com/jasval/iphone-backup"
  url "https://github.com/jasval/iphone-backup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5ea22f0aeb30910e038cd21608d052c7ceb8cff2c3d46bac23cc67d3fbb6c30e"
  license "MIT"
  head "https://github.com/jasval/iphone-backup.git", branch: "main"

  depends_on "rust" => :build
  depends_on "libimobiledevice"
  depends_on :macos

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/iphone-backup"
  end

  def caveats
    <<~EOS
      Run `iphone-backup` to launch the TUI.

      From the Services tab you can:
        [i] install and load the launchd agent (daily backup at 2am)
        [p] pair your iPhone via USB
        [e] change the backup path

      Config: ~/.config/iphone-backup/config.toml
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iphone-backup --version")
  end
end
