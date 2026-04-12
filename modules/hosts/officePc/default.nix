{ self, inputs, ... }:
{
	flake.nixosConfigurations.officePc = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.officePcConfiguration
		];
	};
}
