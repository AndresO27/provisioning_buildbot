# Sample kickstart file for current EL, Fedora based distributions.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --passalgo=sha256 --kickstart
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard --xlayouts='us'
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx

# System timezone
timezone  America/New_York
timesource --ntp-server 192.168.16.1
# Install OS instead of upgrade
#install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
clearpart --all --initlabel --drives=sdx

# Disk partitioning information
part /boot/efi --fstype=efi --grow --maxsize=200 --size=20
part /boot --fstype=ext4 --size=512
part / --fstype=ext4 --grow --asprimary --size=10240 --ondisk=sdx --label=root
part swap --fstype=swap --recommended
part /scratch --fstype=ext4 --grow --asprimary --size=10240 --ondisk=sdx --label=scratch


%pre
wipefs -a
$SNIPPET('log_ks_pre')
$SNIPPET('autoinstall_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
@Core 
@infiniband
@development
bind-utils
vim
psmisc
hwloc
hwloc-gui
chrony
NetworkManager
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza

# remove default AlmaLinux yum repos
# Masters have access to internet no delete them
rm -f /etc/yum.repos.d/almalinux*.repo

# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')

$SNIPPET('add_root_pubkey')
$SNIPPET('add_report_boot')
rm /etc/sysconfig/network-scripts/ifcfg-ipmi
nmcli connection modify ibs2 ipv6.method "disabled"
nmcli connection modify ibs2 connection.autoconnect yes

$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('autoinstall_done')
# End final steps
%end
