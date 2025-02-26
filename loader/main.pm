# SUSE's openQA tests
#
# Copyright 2009-2013 Bernhard M. Wiedemann
# Copyright 2012-2020 SUSE LLC
# SPDX-License-Identifier: FSFAP

use strict;
use warnings;
use testapi qw(check_var get_var get_required_var set_var);
use lockapi;
use needle;
use version_utils ':VERSION';
use File::Find;
use File::Basename;
use DistributionProvider;
use scheduler 'load_yaml_schedule';
use main_containers;

BEGIN {
    unshift @INC, dirname(__FILE__) . '/../../lib';
}
use utils;
use version_utils qw(is_jeos is_gnome_next is_krypton_argon is_leap is_tumbleweed is_rescuesystem is_desktop_installed is_opensuse is_sle is_staging);
use main_common;
use known_bugs;
use YuiRestClient;

init_main();

sub cleanup_needles {
    remove_common_needles;
    for my $distri (qw(opensuse microos)) {
        unregister_needle_tags("ENV-DISTRI-$distri") unless check_var('DISTRI', $distri);
    }
    unregister_needle_tags('ENV-LIVECD-' . (get_var('LIVECD') ? 0 : 1));
    for my $wm (qw(mate lxqt enlightenment awesome)) {
        remove_desktop_needles($wm) unless check_var('DE_PATTERN', $wm);
    }
    unregister_needle_tags('ENV-LEAP-1') unless is_leap;
    unregister_needle_tags('ENV-VERSION-Tumbleweed') unless is_tumbleweed;
    for my $flavor (qw(Krypton-Live Argon-Live GNOME-Live KDE-Live XFCE-Live Rescue-CD JeOS-for-AArch64 JeOS-for-kvm-and-xen)) {
        unregister_needle_tags("ENV-FLAVOR-$flavor") unless check_var('FLAVOR', $flavor);
    }
    unregister_needle_tags('ENV-FLAVOR-JeOS-for-kvm') unless is_jeos;
    # unregister christmas needles unless it is December where they should
    # appear. Unused needles should be disregarded by admin delete then
    unregister_needle_tags('CHRISTMAS') unless get_var('WINTER_IS_THERE');
}

# we need some special handling for the openSUSE winter needles
my @time = localtime();
set_var('WINTER_IS_THERE', 1) if ($time[4] == 11 || $time[4] == 0);

testapi::set_distribution(DistributionProvider->provide());

# Set failures
$testapi::distri->set_expected_serial_failures(create_list_of_serial_failures());
$testapi::distri->set_expected_autoinst_failures(create_list_of_autoinst_failures());

set_var('DESKTOP', check_var('VIDEOMODE', 'text') ? 'textmode' : 'kde') unless get_var('DESKTOP');


if (check_var('TEST', 'create_node')) {
    loadtest "harvester/create_cluster";
}
elsif (check_var('TEST', 'join_node')) {
    loadtest "harvester/join_cluster";
}
elsif (check_var('TEST', 'install_only')) {
    loadtest "harvester/iso_install";
}
elsif (check_var('TEST', 'uefi')) {
    loadtest "harvester/create_cluster_uefi";
}
elsif (check_var('TEST', 'uefi_arm')) {
    loadtest "harvester/create_cluster_uefi";
}

1;
