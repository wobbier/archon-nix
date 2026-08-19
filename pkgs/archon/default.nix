{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "9.6.0";
  pname = "archon";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon/releases/download/v${version}/archon-v${version}.AppImage";
    hash = "sha256-69xo+1jMo91KQ6yoMOBTXLUzFRNGUJqH7G5ZeEiiX4I=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType1 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 /dev/stdin $out/share/applications/${pname}.desktop <<EOF
    [Desktop Entry]
    Name=Archon
    Exec=${pname}
    Icon=${pname}
    Type=Application
    Categories=Game;Utility;
    StartupWMClass=Archon App
    EOF

    install -Dm444 \
      "${appimageContents}/${pname}.png" \
      "$out/share/icons/hicolor/512x512/apps/${pname}.png"
  '';

  meta = {
    description = "Archon is a desktop client for Warcraft Logs, a combat analysis tool for World of Warcraft.";
    homepage = "https://www.archon.gg/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-archon/releases";
    license = lib.licenses.unfree;
    mainProgram = "archon";
    maintainers = with lib.maintainers; [ wobbier ];
    platforms = [ "x86_64-linux" ];
  };
}