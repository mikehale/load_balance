HOST="172.16.209.132"
HOSTS = %w[172.16.209.130 172.16.209.129]
USER="root"
RSYNC="rsync -avz --delete --delete-excluded --exclude '.*'"
TOPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
COMPANY_NAME="halethegeek"
NEW_COOKBOOK_LICENSE= :apachev2