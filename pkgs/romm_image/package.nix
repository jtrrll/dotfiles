{
  lib,
  dockerTools,
}:
(dockerTools.pullImage {
  imageName = "rommapp/romm";
  imageDigest = "sha256:2b7a1714b287f69b081ad2a63bb8c2fa673666a17b2f21322b580b0cd51cb266";
  hash = "sha256-/aYg4BVUAsRxM/lo9e+Vxlj0kk/Gs9eTXa6hnrCrqLA=";
  finalImageName = "rommapp/romm";
  finalImageTag = "4.8.1";
}).overrideAttrs
  (previous: {
    meta = (previous.meta or { }) // {
      description = "Container image for RomM, a self-hosted ROM manager and player";
      platforms = lib.platforms.linux;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  })
