cask "amader-bangla-keyboard" do
  version "1.0.2"
  sha256 "70f5a75266b912e32e84f2c7d8af8794a8e29ac6647a92b0a8202fbc8a167f3b"

  url "https://github.com/amerganim/MacOSBanglaKeyboard/releases/download/v#{version}/AmaderBanglaKeyboard.zip"
  name "Amader Bangla Keyboard"
  desc "Free phonetic Bangla (Bengali) keyboard / input method"
  homepage "https://amerganim.github.io/MacOSBanglaKeyboard/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  input_method "AmaderBanglaKeyboard.app"

  postflight do
    app = "#{Dir.home}/Library/Input Methods/AmaderBanglaKeyboard.app"
    # Free app without a paid Apple certificate: allow it to run.
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", app]
    system_command "/usr/bin/pkill", args: ["-x", "AmaderBanglaKeyboard"], must_succeed: false
    system_command "#{app}/Contents/MacOS/AmaderBanglaKeyboard", args: ["--enable"], must_succeed: false
  end

  uninstall_preflight do
    app = "#{Dir.home}/Library/Input Methods/AmaderBanglaKeyboard.app"
    if File.exist?(app)
      system_command "#{app}/Contents/MacOS/AmaderBanglaKeyboard", args: ["--disable"], must_succeed: false
    end
  end

  uninstall signal: [["TERM", "io.github.amerganim.inputmethod.AmaderBanglaKeyboard"]]

  zap trash: "~/Library/Application Support/AmaderBanglaKeyboard"

  caveats <<~EOS
    One last step (macOS requires you to do it yourself, once):
      System Settings → Keyboard → Text Input → Input Sources → Edit…
      → + → Bangla → "Amader Bangla Keyboard" → Add
    If it is not listed yet, log out and back in.

    Control+Shift+B switches between Bangla and English.
    Typing guide: https://amerganim.github.io/MacOSBanglaKeyboard/guide.html
  EOS
end
