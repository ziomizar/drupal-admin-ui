#!/bin/sh
set -e

# If settings.php doesn't exist, create it and install Drupal
if [ ! -f  /app/demo/docroot/sites/default/settings.php ]; then
    echo "settings.php not detected - installing Drupal (this may take some time, wait for a one-time login link to appear!)"
     chmod 755 /app/demo/docroot/sites/default
     rm -rf \
      composer.json \
      composer.lock \
      config \
      docroot/.ht.router.php \
      docroot/core \
      docroot/modules \
      docroot/sites/default/files \
      docroot/sites/default/settings.php \
      docroot/sites/default/services.yml \
      docroot/sites/simpletest \
      docroot/vfancy \
      reports \
      vendor
    cp /app/demo/docroot/sites/default/default.settings.php /app/demo/docroot/sites/default/settings.php
    echo "\$settings['trusted_host_patterns'] = [
  '^drupal\$',
  '^localhost\$',
  '^drupal-admin-ui\.lndo\.site\$',
  '^127\.0\.0\.1\$',
];" >> /app/demo/docroot/sites/default/settings.php
    cp /app/demo/templates/composer.json /app/demo/composer.json
    cp /app/demo/templates/composer.lock /app/demo/composer.lock
    cp /app/demo/templates/.ht.router.php /app/demo/docroot/.ht.router.php
    echo "\$config_directories['sync'] = '../config/sync';" >> /app/demo/docroot/sites/default/settings.php
    mkdir /app/demo/docroot/sites/default/files /app/demo/docroot/sites/simpletest /app/demo/reports
    chmod 777 /app/demo/docroot/sites/default/files
    cd /app/demo/ && composer install
    composer config repositories.repo-name path "/app/admin_ui_support"
    COMPOSER_MEMORY_LIMIT=-1 composer require justafish/drupal-admin-ui-support:dev-master
    cd /app/demo/docroot
    drush site:install demo_umami -y --db-url=mysql://drupal:drupal@database:3306/drupal --sites-subdir=default
    drush en -y jsonapi admin_ui_support admin_ui_widget_example
    drush config:set -y system.logging error_level verbose
    rm -rf /app/demo/docroot/vfancy
    ln -s /var/www/admin-ui/build/ /app/demo/docroot/vfancy
fi

echo "##############################################################################################
# One time login URL                                                                         #
# $(drush user:login) #
##############################################################################################"
