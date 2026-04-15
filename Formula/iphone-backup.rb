class IphoneBackup < Formula
  desc "Automated iPhone/iPad backup manager with a Ratatui TUI, scheduled via launchd"
  homepage "https://github.com/jasval/iphone-backup"
  url "https://github.com/jasval/iphone-backup/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "132010c2fd2df52fd280d03a26ba40e486082a5c79c7d7d5a4501fb2a962c9e3"
  license "MIT"
  head "https://github.com/jasval/iphone-backup.git", branch: "main"

  depends_on "rust" => :build
  depends_on "libimobiledevice"
  depends_on "jq"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
    (prefix/"scripts").install "scripts/setup.sh"
    (prefix/"scripts").install "scripts/restore.sh"
    (prefix/"config").install "config/com.user.iphone-backup.plist"
  end

  def caveats
    <<~EOS
      To load the launchd agent (runs backup daily at 2 am):
        cp #{prefix}/config/com.user.iphone-backup.plist ~/Library/LaunchAgents/
        launchctl load ~/Library/LaunchAgents/com.user.iphone-backup.plist

      To pair your iPhone via USB (run once per device):
        bash #{prefix}/scripts/setup.sh

      To restore a backup:
        bash #{prefix}/scripts/restore.sh

      Config file: ~/.config/iphone-backup/config.toml
        backup_path = "~/Backups/iOS"   # or an SMB mount like /Volumes/ios-backups
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iphone-backup --version")
  end
end
