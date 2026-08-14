{
  lib,
  stdenvNoCC,
  libretro-shaders-slang,
}:
# Builds a self-contained RetroArch slang shader preset that has no
# runtime dependency on the Nix store.
#
# Pick exactly one:
#   - `reference` (+ `overrides`): wraps an existing upstream preset with
#     #reference. For ds_shader/psp_shader/crt_shader.
#   - `passes` (+ `textures`/`params`/`feedbackPass`): builds a new
#     multi-pass preset from raw shader files.
{
  # Also the output filename's stem (<name>.slangp).
  name,
  description,

  # reference mode
  reference ? null,
  overrides ? { },

  # passes mode
  passes ? null,
  textures ? { },
  params ? { },
  feedbackPass ? "0",
}:
let
  outputSubdir = "shaders_slang";
  presetFileName = "${name}.slangp";
  refPath = p: "${outputSubdir}/${p}";
  paramLine = k: v: ''${k} = "${toString v}"'';

  passDefaults = {
    alias = "";
    scaleTypeX = "source";
    scaleX = "1.000000";
    scaleTypeY = "source";
    scaleY = "1.000000";
    filterLinear = "false";
    wrapMode = "clamp_to_border";
    mipmapInput = "false";
    floatFramebuffer = "false";
    srgbFramebuffer = "false";
  };

  renderPass =
    i: pass:
    let
      p = passDefaults // pass;
    in
    lib.concatStringsSep "\n" [
      (paramLine "shader${toString i}" (refPath p.shader))
      (paramLine "alias${toString i}" p.alias)
      (paramLine "wrap_mode${toString i}" p.wrapMode)
      (paramLine "mipmap_input${toString i}" p.mipmapInput)
      (paramLine "filter_linear${toString i}" p.filterLinear)
      (paramLine "float_framebuffer${toString i}" p.floatFramebuffer)
      (paramLine "srgb_framebuffer${toString i}" p.srgbFramebuffer)
      (paramLine "scale_type_x${toString i}" p.scaleTypeX)
      (paramLine "scale_x${toString i}" p.scaleX)
      (paramLine "scale_type_y${toString i}" p.scaleTypeY)
      (paramLine "scale_y${toString i}" p.scaleY)
    ];

  renderTexture = texName: tex: [
    (paramLine texName (refPath tex.path))
    (paramLine "${texName}_linear" (tex.linear or "false"))
    (paramLine "${texName}_mipmap" (tex.mipmap or "false"))
    (paramLine "${texName}_wrap_mode" (tex.wrapMode or "clamp_to_border"))
  ];

  fromPasses = {
    roots = (map (p: p.shader) passes) ++ (map (t: t.path) (lib.attrValues textures));
    presetText = lib.concatStringsSep "\n\n" (
      [
        (paramLine "shaders" (lib.length passes))
        (paramLine "feedback_pass" feedbackPass)
      ]
      ++ lib.imap0 renderPass passes
      ++ lib.optional (textures != { }) (
        paramLine "textures" (lib.concatStringsSep ";" (lib.attrNames textures))
      )
      ++ (lib.concatLists (lib.mapAttrsToList renderTexture textures))
      ++ (lib.mapAttrsToList paramLine params)
    );
  };

  fromReference = {
    roots = [ reference ];
    presetText = lib.concatStringsSep "\n" (
      [ ''#reference "${refPath reference}"'' ] ++ (lib.mapAttrsToList paramLine overrides)
    );
  };

  generated =
    assert lib.assertMsg (
      reference != null || passes != null
    ) "mkSlangShader ${name}: specify either `reference` or `passes`";
    assert lib.assertMsg (
      reference == null || passes == null
    ) "mkSlangShader ${name}: specify only one of `reference` or `passes`, not both";
    if passes != null then fromPasses else fromReference;
in
stdenvNoCC.mkDerivation {
  pname = name;
  inherit (libretro-shaders-slang) version;

  dontUnpack = true;
  dontBuild = true;
  dontPatchShebangs = true;

  # Plain text/image assets we copied out ourselves -- should be no leftover
  # store references.
  allowedReferences = [ ];

  inherit (generated) presetText;
  passAsFile = [ "presetText" ];

  installPhase = ''
    runHook preInstall

    base=${libretro-shaders-slang}/share/libretro/shaders/shaders_slang
    mkdir -p "$out/${outputSubdir}"

    declare -A seen
    queue=(${lib.concatMapStringsSep " " lib.escapeShellArg generated.roots})

    while [ "''${#queue[@]}" -gt 0 ]; do
      path="''${queue[0]}"
      queue=("''${queue[@]:1}")
      [ -n "''${seen[$path]:-}" ] && continue
      seen[$path]=1

      src="$base/$path"
      dest="$out/${outputSubdir}/$path"
      mkdir -p "$(dirname "$dest")"
      cp "$src" "$dest"

      dir="$(dirname "$path")"
      while IFS= read -r ref; do
        [ -z "$ref" ] && continue
        resolved="$(realpath -m --relative-to="$base" "$base/$dir/$ref")"
        queue+=("$resolved")
      done < <(grep -oE '[A-Za-z0-9_./-]+\.(slang|slangp|inc|png|bmp|tga)' "$src" | sort -u)
    done

    cp "$presetTextPath" "$out/${presetFileName}"

    runHook postInstall
  '';

  meta = {
    inherit description;
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
