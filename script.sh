#!/bin/bash

yum check-update
yum clean all
yum update
cat /etc/redhat-release
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
yum install -y nginx
yum install epel-release
yum install -y certbot-nginx
mkdir -p /etc/nginx/sites-available && mkdir -p /etc/nginx/sites-enabled
sed -i '$ d' /etc/nginx/nginx.conf
echo -e '\tinclude /etc/nginx/sites-enabled/*;\n\tserver_names_hash_bucket_size 64;\n}' >> /etc/nginx/nginx.conf
service nginx restart
# Add domain name {{ domain_name }} config in sites-available
ln -s /etc/nginx/sites-available/{{ domain_name }} /etc/nginx/sites-enabled/{{ domain_name }}
certbot --nginx -d {{ domain_name }} -d {{ domain_name }} --non-interactive --agree-tos -m {{ domain_name }}
mkdir -p /var/www/{{ domain_name }}/html/
# Add a index.html in the folder created above
chcon -Rt httpd_sys_content_t /var/www/
service nginx restart