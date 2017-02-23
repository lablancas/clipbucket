#!/bin/sh

whoami=`whoami`
if [ "${whoami}" != "root" ]; then
  echo "Error: re-run as root"
else

  apt-get -y update
  apt-get -y install sendmail
  
  # Install Apache, MySQL, and PHP
  apt-get -y install apache2
  #apt-get -y install mysql-server
  apt-get -y install php5 libapache2-mod-php5
  
  # Enable mod_rewrite module
  a2enmod rewrite
  
  # Enable dir module with index.php before index.html
  sed 's/ index\.php//' /etc/apache2/mods-available/dir.conf | sed 's/ index\.html/ index.php index.html/' > /tmp/dir.conf
  cat /tmp/dir.conf > /etc/apache2/mods-available/dir.conf
  a2enmod dir
  
  # Configure PHP for Clipbucket
  ini='/etc/php5/apache2/php.ini'
  sed 's/max_execution_time = 30/max_execution_time = 7200/' $ini | sed 's/post_max_size = 8M/post_max_size = 50M/' | sed 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' > /tmp/php.ini 
  cat /tmp/php.ini > $ini
  
  # Install PHP Modules
  apt-get -y install php5-mysql php5-gd php5-curl

  # install SourceGuardian
  cd /home/ubuntu
  curl -X GET "http://www.sourceguardian.com/loaders/download.php?d=linux-x86_64&ixed=ixed.5.5.lin" > /usr/lib/php5/20121212/ixed.5.5.lin
  echo "extension=ixed.5.5.lin" >> /etc/php5/cli/php.ini
  
  # Restart apache to activate modules and configurations
  service apache2 restart
  
  # Install FFMPEG (Auto Installer)
  apt-get -y update
  apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  libtheora-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev
  
  apt-get -y install git unzip subversion libstdc++-4.8-dev g++
  wget http://mirror.ffmpeginstaller.com/old/scripts/ffmpeg8/ffmpeginstaller.8.0.tar.gz
  tar -xzvf ffmpeginstaller.8.0.tar.gz
  cd /home/ubuntu/ffmpeginstaller.8.0
  
  # TODO: revise mplayer.sh to checkout ffmpeg 3.1.3
  # TODO: revise ffmpeg.sh to checkout ffmpeg 3.1.3 and create sym link for ffprobe
  
  ./install.sh
  
  # Install MediaInfo
  apt-get -y install mediainfo
  
  # Install ImageMagick
  apt-get -y install imagemagick
  
  # Create database
  #echo "Creating database (enter MySQL root password)"
  #echo "create database burnout;" | mysql -u root -p
  #echo "CREATE USER 'burnout'@'localhost' IDENTIFIED BY 'Burn0ut.fit';" | mysql -u root -p
  #echo "GRANT ALL ON burnout.* TO 'burnout'@'localhost';" | mysql -u root -p
  
  # install clipbucket
  cd /home/ubuntu
  
  # install Ultimate package plugins and themes TODO: remove once this is in the repo
  unzip Ultimate.zip
  
  if [ "$1" -eg "ucs" ]; then
    rsync -avr "Ultimate/multiserver_legacy/api/" /var/www/html/clipbucket
  else
    git clone https://github.com/lablancas/clipbucket.git clipbucket
    
    cp -R "Ultimate/Adult page warning/cb_warning_page" "clipbucket/upload/plugins/cb_warning_page"
    cp -R "Ultimate/Carousel/cb_carousel" "clipbucket/upload/plugins/cb_carousel"
    cp -R "Ultimate/Honey Captions" "clipbucket/upload/plugins/Honey Captions"
    cp -R "Ultimate/Floating Share Box/cb_floating_share" "clipbucket/upload/plugins/cb_floating_share"
    cp -R "Ultimate/Mass Embedder" "clipbucket/upload/plugins/Mass Embedder"
    cp -R "Ultimate/multiserver_legacy/plugin" "clipbucket/upload/plugins/cb_multiserver"
    cp -R "Ultimate/Piad Subscription Module" "clipbucket/upload/plugins/Piad Subscription Module"
    cp -R "Ultimate/Player Ads Manager" "clipbucket/upload/plugins/Player Ads Manager"
    cp -R "Ultimate/Player Branding/html5_brand_removal" "clipbucket/upload/plugins/cb_html5_player"
    cp -R "Ultimate/SEO Ninja" "clipbucket/upload/plugins/SEO Ninja"
    cp -R "Ultimate/Social Connect" "clipbucket/upload/plugins/Social Connect"
    cp -R "Ultimate/Video Head Control" "clipbucket/upload/plugins/Video Head Control"
    cp -R "Ultimate/Website Branding" "clipbucket/upload/plugins/Website Branding"
    cp -R "Ultimate/YouClip" "clipbucket/upload/plugins/YouClip"
  
    cp -R Ultimate/LiveMotion Ultimate/WeTube Ultimate/Zulu clipbucket/upload/styles/
  
    # copy files to apache web folder
    rsync -avr /home/ubuntu/clipbucket/upload/ /var/www/html/clipbucket
    cd /var/www/html/clipbucket
    chmod a+rwx cache
    chmod a+rwx cache/comments
    chmod a+rwx cache/userfeeds
    chmod a+rwx files
    chmod a+rwx files/conversion_queue
    chmod a+rwx files/logs
    chmod a+rwx files/mass_uploads
    chmod a+rwx files/original
    chmod a+rwx files/photos
    chmod a+rwx files/temp
    chmod a+rwx files/temp/install.me
    chmod a+rwx files/thumbs
    chmod a+rwx files/videos
    chmod a+rwx images
    chmod a+rwx images/avatars
    chmod a+rwx images/backgrounds
    chmod a+rwx images/category_thumbs
    chmod a+rwx images/collection_thumbs
    chmod a+rwx images/groups_thumbs
    chmod a+rwx includes
    chmod a+rwx includes/langs/en.lang
    mkdir plugins/cb_server_thumb/cache
    chmod a+rwx plugins/cb_server_thumb/cache
    
    # setup crontab schedule
    echo "* * * * *       root   php -q /var/www/html/clipbucket/actions/video_convert.php" >> /etc/crontab
    echo "* * * * *       root   php -q /var/www/html/clipbucket/actions/verify_converted_videos.php" >> /etc/crontab
    echo "0 0,12,13 * * * root   php -q /var/www/html/clipbucket/actions/update_cb_stats.php" >> /etc/crontab
    
  fi

  # TODO after completed website installation steps: rm -rf /var/www/html/clipbucket/cb_install
  
fi