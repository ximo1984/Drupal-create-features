#!/bin/bash

categories=( taxonomy menu_custom filter field_base field_instance node views_view user_role user_permission rules_config profile2_type flag elysia_cron feeds_importer)

echo $1 | grep -i 'help' > /dev/null

if [ -z "$1" -o $? == 0 ]
then
  echo "This scripts exports the configuration to features using a layered approach."
  echo "It will export features in a specific order and will enable them."
  echo "Usage: create_features.sh [profile name]"
  exit 1
fi

PAQUETE=$1

read -p "You are going to create / recreate all the features. Are you sure you want to continue? [Y/n] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  for i in ${categories[@]}
  do
    feature_name=${PAQUETE}_$i
    if [ -f "modules/feature/${feature_name}/${feature_name}.info" ]
    then
      echo "Feature ${feature_name} already exists, we will increment the version number"
      drush fe $feature_name "$i:" --destination=profiles/${PAQUETE}/modules/feature --version-increment -y
    else
      echo "We will create the feature ${feature_name}"
      drush fe $feature_name "$i:" --destination=profiles/${PAQUETE}/modules/feature --version-set="7.x-1.0" -y
      sed -i "s/package = Features/package = Features ${PAQUETE}/" modules/feature/${feature_name}/${feature_name}.info
      drush en $feature_name -y
    fi
  done

  drush cc all
fi
