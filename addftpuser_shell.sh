#!/bin/bash
#
#The Shell is ADD new FTP user#
#

while true; do
	read -p "请输入要新建的FTP用户的账号：" ftpname
	if [ -n "$ftpname" ]; then
		if [ $(grep "$ftpname" /etc/vsftpd/vsftpd_user_conf) ]; then
			echo "该用户已存在，请重新输入"
			continue;
		else
			break;
		fi
	else	
		continue;
	fi
done

while true; do
	read -p "请输入密码：" ftppwd
	if [ -n "$ftppwd" ]; then
		break;
	else	
		continue;
	fi
done


mkdir -p /www/vsftp/$ftpname/
useradd -g ftp -M -d /www/vsftp/$ftpname -s /sbin/nologin $ftpname
echo "$ftppwd" | passwd $ftpname --stdin

chown -R $ftpname.ftp  /www/vsftp/$ftpname/

chmod 777 /www/vsftp/$ftpname/

touch /etc/vsftpd/vsftpd_user_conf/$ftpname

echo -e "local_root=/www/vsftp/$ftpname/\nwrite_enable=YES\nanon_world_readable_only=NO\nanon_upload_enable=YES\nanon_mkdir_write_enable=YES\nanon_other_write_enable=YES" >> /etc/vsftpd/vsftpd_user_conf/$ftpname
