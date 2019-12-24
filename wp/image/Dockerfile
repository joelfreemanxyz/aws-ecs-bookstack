FROM wordpress as wp-files
RUN apt-get update; \
   apt-get install wget sed unzip -y
RUN mkdir /files/
WORKDIR /files/
COPY wp-plugin-config.php wp-plugin-config.php
RUN sed -i '81,$d' /usr/src/wordpress/wp-config-sample.php && \
    cat /usr/src/wordpress/wp-config-sample.php wp-plugin-config.php > wp-config-sample.php
RUN wget https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.3.2.zip
RUN unzip amazon-s3-and-cloudfront.2.3.2 && rm amazon-s3-and-cloudfront.2.3.2.zip

FROM wordpress
COPY --from=wp-files /files/amazon-s3-and-cloudfront /usr/src/wordpress/wp-content/plugins/
COPY --from=wp-files /files/wp-config-sample.php /usr/src/wordpress/wp-config.php
ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "apache2-foreground" ]