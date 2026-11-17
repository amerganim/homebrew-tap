cask "amader-bangla-keyboard" do
  version "1.0.3"
  sha256 "812e2dbc04da92dcce739daffa25801c36b292b1e7162e398f70507cb119f99d"

  url "https://github.com/amerganim/MacOSBanglaKeyboard/releases/download/v#{version}/AmaderBanglaKeyboard.zip"
  name "Amader Bangla Keyboard"
  desc "Free phonetic Bangla (Bengali) keyboard / input method"
  homepage "https://amerganim.github.io/MacOSBanglaKeyboard/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  input_method "AmaderBanglaKeyboard.app"

  postflight_steps do
    # Free app without a paid Apple certificate: allow it to run.
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "Library/Input Methods/AmaderBanglaKeyboard.app"],
        chdir:          "/Users/{{user}}",
        writable_paths: ["Library/Input Methods/AmaderBanglaKeyboard.app"],
        writable_base:  :home,
        must_succeed:   false
    terminate_process "AmaderBanglaKeyboard"
    run "Library/Input Methods/AmaderBanglaKeyboard.app/Contents/MacOS/AmaderBanglaKeyboard",
        args:         ["--enable"],
        base:         :home,
        must_succeed: false,
        print_stderr: false
  end

  uninstall_preflight_steps do
    if_path_exists "Library/Input Methods/AmaderBanglaKeyboard.app", base: :home do
      run "Library/Input Methods/AmaderBanglaKeyboard.app/Contents/MacOS/AmaderBanglaKeyboard",
          args:         ["--disable"],
          base:         :home,
          must_succeed: false,
          print_stderr: false
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
