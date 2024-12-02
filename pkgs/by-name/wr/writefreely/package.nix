{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "writefreely";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "jbgi";
    repo = pname;
    rev = "aa6eb6c4a41783d05f7529971ea170fdfdd954e9";
    sha256 = "sha256-EXLeCPS+79xKj+nU8HvpDS+mRmzr6jtS4qyQNC8Ryu0=";
  };

  vendorHash = "sha256-g5JdmWf+UKwuBoTrc+/ugAZzhFJwl/as/mmJduWWPRY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/writefreely/writefreely.softwareVer=${version}"
  ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  passthru.tests = {
    inherit (nixosTests) writefreely;
  };

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ soopyc ];
    mainProgram = "writefreely";
  };
}
