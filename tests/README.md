## Test Module

Usage: Individual test case written in Perl to be execute for different user scenarios, the sequence and condition defined in test loader file `main.pm`

Refer to https://open.qa/docs/#_how_to_write_tests  

1. We place test module files /var/lib/openqa/tests/opensuse/tests/harvester

2. Trigger individual test case 

    We use `isos post` manner with `openqa-cli` command to trigger specific test module
    * Mandatory parameter to trigger test through openqa-cli
    - ISO
    - DISTRI
    - VERSION
    - FLAVOR
    - ARCH


    ```
    $ cd /var/lib/openqa/tests/opensuse/products
    $ openqa-cli api -X POST jobs TEST=create_node ISO=harvester-v1.4.0-rc5-amd64.iso DISTRI=opensuse VERSION=1.4.0-rc5 FLAVOR=ISO ARCH=x86_64 --apikey <key> --apisecret <secret>
    ```