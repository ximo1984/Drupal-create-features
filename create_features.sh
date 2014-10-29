#!/bin/bash
array=( taxonomy field_base field_instance node views_view user_role user_permission rules_config profile2_type flag elysia_cron)
PAQUETE="estudios"
for i in ${array[@]}
do
	feature_name=${PAQUETE}_$i
	if [ -f "sites/all/modules/features_estudios/${feature_name}/${feature_name}.info" ]
	then
		echo "Feature ${feature_name} exist, we will increment version feature"
		drush fe $feature_name "$i:" --destination=sites/all/modules/features_estudios --version-increment -y
	else
		echo "We will create feature ${feature_name}"
		drush fe $feature_name "$i:" --destination=sites/all/modules/features_estudios --version-set="7.x-1.0" -y
		sed -i "s/package = Features/package = Features ${PAQUETE}/" sites/all/modules/features_estudios/${feature_name}/${feature_name}.info
		drush en $feature_name -y
	fi
done
drush cc all