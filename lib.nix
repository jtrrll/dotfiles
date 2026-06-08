{ lib }:
{
  importFromDirectory =
    {
      nameFn ? lib.replaceStrings [ "_" ] [ "-" ],
      importFn,
    }:
    directory:
    lib.concatMapAttrs (
      name: type:
      if type == "directory" then
        {
          "${nameFn name}" = importFn "${directory}/${name}";
        }
      else
        { }
    ) (builtins.readDir directory);
}
