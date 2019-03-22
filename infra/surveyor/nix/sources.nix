# This file has been generated by Niv.

# A record, from name to path, of the third-party packages
with rec
{
  pkgs = import <nixpkgs> {};

  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  mapAttrs = builtins.mapAttrs or
    (f: set: with builtins;
      listToAttrs (map (attr: { name = attr; value = f attr set.${attr}; }) (attrNames set)));

  getFetcher = spec:
    let fetcherName =
      if builtins.hasAttr "type" spec
      then builtins.getAttr "type" spec
      else "tarball";
    in builtins.getAttr fetcherName {
      "tarball" = pkgs.fetchzip;
      "file" = pkgs.fetchurl;
    };
};
# NOTE: spec must _not_ have an "outPath" attribute
mapAttrs (_: spec:
  if builtins.hasAttr "outPath" spec
  then abort
    "The values in sources.json should not have an 'outPath' attribute"
  else
    if builtins.hasAttr "url" spec && builtins.hasAttr "sha256" spec
    then
      spec //
      { outPath = getFetcher spec { inherit (spec) url sha256; } ; }
    else spec
  ) sources