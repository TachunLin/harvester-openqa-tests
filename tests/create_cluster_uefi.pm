use Mojo::Base "basetest";
use testapi;
use Time::HiRes 'sleep';

sub run {
    # wait for bootloader to appear
    # with a timeout explicitly lower than the default because
    # the bootloader screen will timeout itself
    # assert_screen "bootloader", 15;

    assert_screen "confirm_hardware_check", 45;

    # select to accept Hardware checks
    send_key "ret";

    ## Page: Choose installation mode page
    assert_screen "select_installation_mode";

    # select Create Harvester cluster
    send_key "ret"; 

    ## Page: Disk selection page on UEFI bios
    assert_screen "uefi_choose_installation_disk_v121";


    send_key "ret"; #Click "enter" on the Installation disk

    send_key "ret"; #Click "enter" on the Persistent size 
    
    send_key "ret"; #Click "enter" to proceed to hostname page


    # Page - Configure Network
    send_key "tab"; #Click tab in Management NIC field
    sleep 3;
    send_key "spc"; #Click space to select Management NIC field

    send_key "ret"; #Click "enter" to select the Management NIC



    send_key "ret"; #Click enter to select the VLAN ID

    send_key "ret"; #Click enter on Bond Mode field

    assert_screen "image_create_config_management-NIC";

    send_key "ret"; #Click enter use the IPv4 Method

    sleep 10;

    # Page Configure hostname

    assert_screen "image_configure_hostname";

    type_string "n1-create"; #Enter value in Cluster token field

    send_key "ret"; #Click "enter" to enter hostname

    # Configure DNS Servers Page #

    sleep 5;
    assert_screen "configure_dns_new";
    send_key "ret"; #Click enter on DNS Servers field and procced to next page

    # Configure VIP Page #

    sleep 5;

    assert_screen "configure_vip_dhcp", 60;
    send_key "ret"; #Click enter on VIP mode field
    
    assert_screen "dhcp_vip_assigned";

    send_key "ret"; #Click enter on VIP field to proceed to next page


    # Configure Cluster token #

    assert_screen "configure_cluster_token_empty";

    type_string "harvester"; #Enter value in Cluster token field

    assert_screen "configure_cluster_token_harvester";

    send_key "ret"; #Click enter on Cluster token field and procced to next page


    # Page Configure Password 
    assert_screen "configure_the_password";

    type_string "passwd"; #Enter value in the password field
    send_key "ret"; #Click enter 

    type_string "passwd"; #Enter value in the confirm password field
    send_key "ret"; #Click enter to proceed 

    # Optional: Configure NTP Servers page#
    assert_screen "configure_ntp_server_140";
    send_key "ret"; #Click enter on NTP Servers field and procced to next page

    # Optional: Configure proxy page#
    assert_screen "configure_proxy";
    send_key "ret"; #Click enter on Proxy address field and procced to next page

    # Optional: import SSH keys page#
    assert_screen "import_ssh_keys";
    send_key "ret"; #Click enter on Http URL field and procced to next page

    # Optional: remote Harvester config page#
    assert_screen "remote_harvester_config";
    send_key "ret"; #Click enter on Http URL field and procced to next page

    # Confirm installation options page#
    assert_screen "create_cluster-confirm_install_option_140";
    send_key "ret"; #Click enter on Yes field and ready to install harvester


    # Confirm start the console setting progress
    assert_screen "installation_ongoing_console_v140", 900;


    # Confirm can successfully install Harvester
    assert_screen "console_install_success_v121", 600;

}

sub test_flags {
    return {fatal => 1};
}

1;
