use Mojo::Base "basetest";
use testapi;
use Time::HiRes 'sleep';

sub run {
    # wait for bootloader to appear
    # with a timeout explicitly lower than the default because
    # the bootloader screen will timeout itself
    # assert_screen "bootloader", 15;

    assert_screen "confirm_hardware_check_150", 45;

    # select to accept Hardware checks
    send_key "ret";

    ## Page: Choose installation mode page
    assert_screen "choose_install_mode_150";
 
    # select Create Harvester cluster
    send_key "ret"; 

    # Page Configure Password
    assert_screen "change_password";

    type_string "passwd"; #Enter value in the password field
    send_key "ret"; #Click enter 

    type_string "passwd"; #Enter value in the confirm password field
    send_key "ret"; #Click enter to proceed

    ## Page: Disk selection page 
    assert_screen "choose_install_disk_150";

    send_key "ret"; #Click "enter" on the Choose installation disk

    send_key "ret"; #Click "enter" on the Use the Persistence size

    send_key "ret"; #Click "enter" on the Use MBR partition scheme

    send_key "ret"; #Click "enter" to proceed to next screen

    # Page - Configure Network
    send_key "tab"; #Click tab in Management NIC field
    sleep 3;
    send_key "spc"; #Click space to select Management NIC field

    send_key "ret"; #Click "enter" to select the Management NIC

    send_key "ret"; #Click enter to select the VLAN ID
    #type_string "100"; #Click enter VLAN ID 100
    #send_key "ret";

    send_key "ret"; #Click enter on Bond Mode field

    #assert_screen "configure_network_150";

    send_key "tab";  #Click tab on the IPv4 Method
    send_key "down"; #Select Static IP

    send_key "ret"; #Click enter use this IPv4 Method

    type_string "10.0.2.100/24"; #Input static IP
    send_key "ret";

    send_key "ret"; #Automatic provide mask 255.255.254.0

    type_string "10.0.2.2"; #Inpu gateway IP
    send_key "ret";

    assert_screen "configure_cluster_network_static";

    send_key "ret"; # Use default empty mtu

    sleep 10;

    # Configure cluster network

    send_key "ret"; #Click enter to input Pod CIDR

    send_key "ret"; #Click enter to input Service CIDR

    send_key "ret"; #Click enter to input Cluster DNS IP

    # Page Configure hostname

    assert_screen "configure_hostname_150";

    type_string "n1-create"; #Enter value in Cluster token field

    send_key "ret"; #Click "enter" to enter hostname

    # Configure DNS Servers Page #

    sleep 5;
    assert_screen "configure_dns_150";
    type_string "8.8.8.8"; #Input global DNS server value
    send_key "ret"; #Click enter on DNS Servers field and procced to next page

    # Configure VIP Page #

    sleep 5;
    assert_screen "configure_vip_dhcp_150", 60;
    send_key "tab";  #Click tab on the IPv4 Method
    send_key "down"; #Select Static IP
    send_key "ret";

    type_string "10.0.2.101";

    assert_screen "static_vip_assigned";
    send_key "ret"; #Click enter on VIP field to proceed to next page


    # Configure Cluster token #

    assert_screen "configure_cluster_token_empty_150";

    type_string "harvester"; #Enter value in Cluster token field

    assert_screen "configure_cluster_token_harvester_150";

    send_key "ret"; #Click enter on Cluster token field and procced to next page

    # Optional: Configure NTP Servers page#
    assert_screen "configure_ntp_server_150";
    send_key "ret"; #Click enter on NTP Servers field and procced to next page

    # Optional: Configure proxy page#
    assert_screen "configure_proxy_150";
    send_key "ret"; #Click enter on Proxy address field and procced to next page

    # Optional: import SSH keys page#
    assert_screen "import_ssh_keys_150";
    send_key "ret"; #Click enter on Http URL field and procced to next page

    # Optional: remote Harvester config page#
    assert_screen "remote_harvester_config_150";
    send_key "ret"; #Click enter on Http URL field and procced to next page

    # Confirm installation options page#
    assert_screen "create_confirm_install_static_170";
    send_key "ret"; #Click enter on Yes field and ready to install harvester


    # Confirm start the console setting progress
    assert_screen "console_config_ongoing_150", 900;


    # Confirm can successfully install Harvester
    assert_screen "console_install_success_150", 900;


}

sub test_flags {
    return {fatal => 1};
}

1;
