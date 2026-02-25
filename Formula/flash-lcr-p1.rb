class FlashLcrP1 < Formula
  desc "Flash firmware to the Fnirsi LCR-P1 LCR meter over USB serial (CH340/CH341)"
  homepage "https://github.com/threebytesfull/flash-lcr-p1"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/threebytesfull/flash-lcr-p1/releases/download/v0.1.0/flash-lcr-p1-aarch64-apple-darwin.tar.xz"
      sha256 "99126ac2d4ae6703d5c0dc1ef255d2bcef0781a9defc3a7dd886eb290583952e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/threebytesfull/flash-lcr-p1/releases/download/v0.1.0/flash-lcr-p1-x86_64-apple-darwin.tar.xz"
      sha256 "46ac55532c3dd472deea3376ad42a9c2de17cfee8a3180c10de949bccf48533c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/threebytesfull/flash-lcr-p1/releases/download/v0.1.0/flash-lcr-p1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c05e77d07db9dce27bc4de76524f5b20f95c838e2e70ab7a3c18641fccde08a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/threebytesfull/flash-lcr-p1/releases/download/v0.1.0/flash-lcr-p1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "288acdfb655eed93190f8249a60911860d7ed9f471524f399212862ed3a3dde3"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "flash-lcr-p1" if OS.mac? && Hardware::CPU.arm?
    bin.install "flash-lcr-p1" if OS.mac? && Hardware::CPU.intel?
    bin.install "flash-lcr-p1" if OS.linux? && Hardware::CPU.arm?
    bin.install "flash-lcr-p1" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
