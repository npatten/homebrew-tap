class Clew < Formula
  desc "A lightweight, local, git-native project tracker for humans and agents."
  homepage "https://github.com/npatten/Clew"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/npatten/Clew/releases/download/v0.1.2/clew-aarch64-apple-darwin.tar.xz"
      sha256 "df3561786e2edb2fe24f4f286e19983790a137de763cae92a326965f59c5f0a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/npatten/Clew/releases/download/v0.1.2/clew-x86_64-apple-darwin.tar.xz"
      sha256 "4b77b129130049163fd85e80bc7f75f842914019ec6945f1e25c6311ce11f8e9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/npatten/Clew/releases/download/v0.1.2/clew-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "eb0b711858dddcbc607c98b3e5973b50e577d2ca55ab950f0f51d6743e5804c5"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "clew" if OS.mac? && Hardware::CPU.arm?
    bin.install "clew" if OS.mac? && Hardware::CPU.intel?
    bin.install "clew" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
