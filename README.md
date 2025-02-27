# harvester-openqa-tests
openQA automation test for Harvester iso installation

[openQA](https://open.qa/) is an automated test tool that makes it possible to test the whole installation process of an operating system. It uses virtual machines to reproduce the process, check the output (both serial console and screen) in every step 

We leverage openQA to test [Harvester ISO installation](https://docs.harvesterhci.io/v1.4/install/index) process

    {{< image "./static/images/openqa_harvester.png" >}}

Test scripts extend from [ os-autoinst](https://github.com/os-autoinst/os-autoinst) code structure to focus on verifying different Harvester ISO installation user scenarios 


### Setup Environment

### Software Requirements
* OS: openSUSE Leap and openSUSE Tumbleweed
* Required packages can be installed from zypper in `openqa-bootstrap` script


### Hardware requirements
To run tests based on the default qemu backend the following hardware specifications are recommended for running openQA test for `multiple nodes` Harvester cluster

* 12x CPU core with 24x hyperthreads (or 24x CPU cores)
* 48GB RAM
* 1TB HDD (preferably SSD or NVMe)
* Internet connection


#### Prerequisites
1. openQA prerequisite package
1. Installed openQA tool and service
1. Prepare the Harvester ISO image file

#### Setup openQA tools and services
We use the [Quick bootstrapping under openSUSE](https://open.qa/dos/#bootstrapping) to provision the openQA service from scratch 

1. Get openqa-bootstrap​ script
    ```
    $ sudo zypper in openQA-bootstrap /usr/share/openqa/script/openqa-bootstrap​
    ```
1. Use bootstrap script to clone an existing job (replace the job id if you want to refer to any existing job)
    ```
    $ sudo /usr/share/openqa/script/openqa-bootstrap --from openqa.opensuse.org 12345 SCHEDULE=tests/boot/boot_to_desktop,tests/x11/kontact​
    ```
1. Setup a local apache server ​
    ```
    $ sudo /usr/share/openqa/script/configure-web-proxy
    ```
1. Use **a2enmod** command to enable the 'headers', 'proxy', 'proxy_http', 'proxy_wstunnel' and 'rewrite' modules.

1. Disable TLS/SSL in /etc/openqa/openqa.ini​
    ```
    [openid]
    ​httpsonly = 0​
    ```
1. Check connection to local PostgreSQL database​ in /etc/openqa/database.ini
    ```
    [production]​
    dsn = dbi:Pg:dbname=openqa
    ```
1. Use Fake authentication in /etc/openqa/client.conf​
   - OpenID (default), OAuth2 and Fake (for development).​

    Fake authentication bypass any authentication and automatically 
    allow any login requests as 'Demo user' with administrator privileges and without password.

    ```
    [auth]
    # method name is case sensitive!
    method = Fake
    ```
1. Launch WebUI required services
   - Check connection to local PostgreSQL database
   - start openQA and enable it to run on each boot call
    ```
    systemctl enable --now postgresql
    systemctl enable --now openqa-webui
    systemctl enable --now openqa-scheduler
    systemctl restart apache2
    ```

1. Access openQA WebUI
- The openQA web UI should be available on http://localhost/ now.
- Click the login button, automatically login with Demo user (Fake authentication)

    {{< image "./static/images/openqa_dashboard.png" >}}


#### Setup openQA workers
1. Setup openQA worker
    ```
    $ sudo zypper in openQA-worker
    ```
1. Create new API in the manage API page 
1. Add non-expired API key to /etc/openqa/client.conf (for example)
    ```
    [localhost]
    key = B7ABFB7F87A62303
    secret = 9C0F5FA0050B2F68
    ```
1. Start openqa-worker instance
    ```
    $ systemctl start openqa-worker@1
    ```
You can start as many workers as you need, you just need to supply a different 'instance number' (the number after @).


--- 

### Project structure

1. loader: 
   - main.pm
   - Usage: boots into desktop when pressing enter at the boot loader screen. 
1. tests:
   - test_name.pm
   - an individual test case in a single perl module file, e.g. "create_cluster.pm". 
1. template:
   - template-harvester
   - Job template to specify which machine, medium type, test suites and job group to become the test environment
1. needles:
   - needle_area.png
   - needle_area.json
   - One of the main mechanisms for openQA to know the state of the virtual machine is checking the presence of some elements in the machine’s 'screen'. This is performed using fuzzy image matching between the screen and the so called 'needles'.
   - A needle consists of a full screenshot in PNG format and a json file with the same name (e.g. foo.png and foo.json)

---

### Setup project files to openQA service folder

After we provisioned the openQA tool and service running well on the host machine

Then we can move the related project files in each folder to the openQA service destination folder

* tests/* -> /var/lib/openqa/tests/opensuse/tests/harvester
* template/* -> /var/lib/openqa/tests/opensuse/products/opensuse
* loader/* -> /var/lib/openqa/tests/opensuse/products/opensuse
* needles/* -> /var/lib/openqa/tests/opensuse/products/opensuse/needles

---

### Load template

We need to load the job template to create all required resources to execute openQA test on Harvester including Medium types, Machines, Test suites and Job groups

Load the template with command 

```
In template folder
$ ./templates-harvester --apikey B7ABFB7F87A62303 --apisecret 9C0F5FA0050B2F68 
```

---

### Prepare Harvester ISO image

1. We can get the ISO image file from https://github.com/harvester/harvester/releases 

2. And place the ISO image to the /var/lib/openqa/factory/iso 

3. Then specify the image file name int the `openqa-cli` parameter to trigger the test 


---
### Trigger test

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