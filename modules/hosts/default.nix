{ self, inputs, ... }:
{
	flake.nixosConfigurations.officePc = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.officePcConfiguration
		];
	};

	flake.nixosConfigurations.tv = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.tvConfiguration
		];
	};
}
