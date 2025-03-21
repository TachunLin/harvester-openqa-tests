use Mojo::Base "basetest";
use testapi;
use Time::HiRes 'sleep';

sub run {
    # wait for bootloader to appear
    # with a timeout explicitly lower than the default because
    # the bootloader screen will timeout itself
    # assert_screen "bootloader", 15;

   
    ## Page: Choose installation mode page
    assert_screen "select_installation_mode", 45;

    send_key "down";

    # select Join Harvester cluster
    send_key "ret"; 

    ## Page: Disk selection page 
    assert_screen "choose_installation_disk";

    send_key "ret"; #Click "enter" on the Choose installation disk

    send_key "ret"; #Click "enter" on the Use the Persistence size

    send_key "ret"; #Click "enter" on the Use MBR partition scheme

    send_key "ret"; #Click "enter" to proceed to next screen

    ## Page Configure hostname

    assert_screen "image_configure_hostname";

    type_string "n1-create"; #Enter value in Cluster token field

    send_key "ret"; #Click "enter" to enter hostname


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

    # Configure DNS Servers Page #

    sleep 5;
    assert_screen "configure_dns_new";
    send_key "ret"; #Click enter on DNS Servers field and procced to next page

    # Configure Management Address #

    #assert_screen "test";

    sleep 1080;

    type_string "10.0.2.16"; #Enter management VIP address

    send_key "ret"; #Click enter on management address and procced to next page


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
    assert_screen "configure_ntp_server_new";
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
    assert_screen "create_cluster-confirm_install_option_v121";
    send_key "ret"; #Click enter on Yes field and ready to install harvester


    # Confirm start the console setting progress
    assert_screen "installation_ongoing_console_v121", 900;


    # Confirm can successfully install Harvester
    assert_screen "console_install_success_v121", 600;

}

sub test_flags {
    return {fatal => 1};
}

1;
