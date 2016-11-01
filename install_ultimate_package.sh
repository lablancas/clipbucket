CB_HOME=/home/admin/web/trial.com/public_html

# install Ultimate package
unzip Ultimate.zip
cp -R "Ultimate/Adult page warning/cb_warning_page" "$CB_HOME/plugins/cb_warning_page"
cp -R "Ultimate/Carousel/cb_carousel" "$CB_HOME/plugins/cb_carousel"
cp -R "Ultimate/Honey Captions" "$CB_HOME/plugins/honey_captions"
cp -R "Ultimate/Floating Share Box/cb_floating_share" "$CB_HOME/plugins/cb_floating_share"
cp -R "Ultimate/Mass Embedder" "$CB_HOME/plugins/cb_mass_embed"
cp -R "Ultimate/multiserver_legacy/plugin" "$CB_HOME/plugins/cb_multiserver"
cp -R "Ultimate/Piad Subscription Module" "$CB_HOME/plugins/paid_subscription"
cp -R "Ultimate/Player Ads Manager" "$CB_HOME/plugins/cb_uads_manager"
cp -R "Ultimate/Player Branding/html5_brand_removal" "$CB_HOME/plugins/cb_html5_player"
cp -R "Ultimate/SEO Ninja" "$CB_HOME/plugins/seo_ninja"
cp -R "Ultimate/Social Connect" "$CB_HOME/plugins/adv_social_connect"
cp -R "Ultimate/Video Head Control" "$CB_HOME/plugins/head_control"
cp -R "Ultimate/Website Branding" "$CB_HOME/plugins/brand_removal"
cp -R "Ultimate/YouClip" "$CB_HOME/plugins/youclip"

cp -R Ultimate/Zulu $CB_HOME/styles/
chmod -R a+rwx $CB_HOME/styles/*

# install font-awesome
unzip font-awesome-4.6.3.zip
mv font-awesome-4.6.3 $CB_HOME/styles/Zulu/theme/css/

# install ruby and rubygems
yum -y install ruby
wget https://rubygems.org/rubygems/rubygems-2.6.6.tgz
tar -xzvf rubygems-2.6.6.tgz
cd rubygems-2.6.6
ruby setup.rb
cd ../
rm -rf rubygems-2.6.6.tgz rubygems-2.6.6

# install flvtool2
gem install flvtool2

echo "TODO: include [$CB_HOME/styles/Zulu/theme/css/font-awesome-4.6.3/css/font-awesome.min.css] into [global_header.html]"
