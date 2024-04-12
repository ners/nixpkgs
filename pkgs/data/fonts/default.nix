{ lib, newScope, runCommandWith, stdenvNoCC, buildEnv, fontforge, ... }:
lib.makeScope newScope (self:
  let
    fonts = lib.filesystem.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./.;
    };

    fontTypes = {
      ttf.installDir = "truetype";
      otf.installDir = "opentype";
      woff.installDir = "woff";
      woff2.installDir = "woff2";
    };
  in
  lib.attrsets.unionOfDisjoint fonts {
    fontBuilder = { pname, version ? null, src, subdir, meta ? {} }: { targetExt, installDir }:
      runCommandWith {
        stdenv = stdenvNoCC;
        name =
          if version == null then
            "${pname}-${targetExt}"
          else
            "${pname}-${targetExt}-${version}";
        derivationArgs = {
          inherit meta;
          ${if version == null then null else "version"} = version;
          nativeBuildInputs = [ fontforge ];
        };
      } ''
        declare -a fileExtensions=(${lib.escapeShellArgs (lib.attrNames fontTypes)})

        for ext in ${targetExt} ''${fileExtensions[@]}; do
          while IFS= read -r -d $'\0' file; do
            fn=$(basename "$file" ".$ext")
            targetDir=$out/share/fonts/${installDir}
            targetFile=$targetDir/$fn.${targetExt}
            if [[ ! -f "$targetFile" ]]; then
              mkdir -p $targetDir
              if [[ "$ext" == ${targetExt} ]]; then
                echo "Copying $file"
                cp "$file" "$targetFile"
              else
                echo "Converting $file to ${targetExt}"
                fontforge --lang=ff -c 'Open($1); Generate($2)' "$file" "$targetFile"
              fi
            fi
          done < <(find ${src}/${subdir} -name "*.$ext" -print0)
        done
      '';
    buildFont = args:
      let
        types = lib.mapAttrs (name: value:
          self.fontBuilder args (value // { targetExt = name; })
        ) fontTypes;
      in
      buildEnv {
        name = args.pname;
        paths = lib.attrValues types;
      } // types;

  }
)
