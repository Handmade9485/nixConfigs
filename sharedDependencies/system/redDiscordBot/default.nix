{
    stdenv,
    lib,
    python311Packages,
    fetchFromGitHub,
    fetchPypi
}:

python311Packages.buildPythonApplication rec {
    pname = "Red-DiscordBot";
    version = "3.5.11";
    pyproject = true;

    src = fetchFromGitHub {
        owner = "Cog-Creators";
        repo = "Red-DiscordBot" ;
        rev = "3.5.13";
        sha256 = "sha256-RHIxMSKbey+m5rsMLZ4xa/GEG2hjR6xdlK5ny+vu4Jo=";
    };


    dependencies = with python311Packages ;[
        aiosignal
        apsw
        attrs
        babel
        brotli
        click
        distro
        multidict
        orjson
        platformdirs
        psutil
        pygments
        python-dateutil
        pyyaml
        rapidfuzz
        schema
        six
        typing-extensions
        frozenlist
        markdown
        markdown-it-py
        setuptools
    ];

    meta = {
        description = "A multi-function Discord bot";
        homepage = "https://docs.discord.red/";
        license = lib.licenses.gpl3;
    };
}
