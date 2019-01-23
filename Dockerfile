FROM nginx:alpine

COPY ./nginx.conf /etc/nginx/conf.d/default.template

# We need to apply the environment variables in the CMD (the command executed when the container is started) since we want to be able to customize them when running the container instead of defining them during build. Because nginx doesn't support environment variables, we have to use the envsubst command instead to apply them to the nginx config file right before starting nginx.
# More info: https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration
# Use the `VIRTUAL_HOST` environment variable by default to make this a minimal config when used in combination with `nginx-proxy`. If you wish to customize the domain, you can use `GAPROXY_HOST` instead.
CMD GAPROXY_HOST="${GAPROXY_HOST:=$VIRTUAL_HOST}" \
	envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf \
	&& echo "Starting nginx" \
	&& exec nginx -g 'daemon off;'
