#!/bin/bash
#
#The Shell is install and config to The VSftpd Server for The Centos7#
#


if [ $USER != "root" ]; then	
	echo "请用root 或者 sudo 来运行"
	exit 1
fi

if [ $( rpm -qa vsftpd ) ];then
	echo "VSftpd已安装";
else
	echo "开始安装VSFTPD，安装完后自动配置，请等待";

#安装VSFTPD#
yum install -y vsftpd
yum install -y psmisc net-tools systemd-devel libdb-devel perl-DBI
systemctl start vsftpd.service
systemctl enable vsftpd.service

#配置VSFTPD#
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf-bak

sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#listen=NO/listen=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/listen_ipv6=YES/#listen=YES/g" '/etc/vsftpd/vsftpd.conf'

echo -e "dual_log_enable=YES\nlocal_root=/www/vsftp/\nuser_config_dir=/etc/vsftpd/vsftpd_user_conf " >> /etc/vsftpd/vsftpd.conf
#echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=300\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=vsftpd\nuser_config_dir=/etc/vsftpd/vconf\nvirtual_use_local_privs=YES\npasv_min_port=10060\npasv_max_port=10090\naccept_timeout=5\nconnect_timeout=1" >> /etc/vsftpd/vsftpd.conf

while true; do
	read -p "请输入公网ip地址：" ftpip
	if [ -n "$ftpip" ]; then
		break;
	else	
		continue;
	fi
done

echo -e "pasv_address=$ftpip" >> /etc/vsftpd/vsftpd.conf

#---------------------------------------------------------------------#

#关闭SELINUX#
sed -i "s/SELINUX=enforcing/#SELINUX=enforcing/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g" /etc/selinux/config
echo -e "SELINUX=disabled\n" >> /etc/selinux/config
#使配置立即生效#
setenforce 0

#---------------------------------------------------------------------#

#重启VSFTPD#
systemctl restart vsftpd.service

fi
#-----------------------------------------------------------------------------#