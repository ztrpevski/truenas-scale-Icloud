FROM boredazfcuk/icloudpd:latest

ENV config_dir="/config" XDG_DATA_HOME="/config" TZ="UTC"

ARG icloudpd_version="latest"
ARG python_version="3.11"
ARG build_dependencies="git gcc python3-dev musl-dev rust cargo libffi-dev openssl-dev"
ARG app_dependencies="py3-pip exiftool coreutils tzdata curl imagemagick shadow jq libheif jpeg bind-tools traceroute"
ARG fix_repo="boredazfcuk/icloud_photos_downloader"

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** Build started for boredazfcuk's docker-icloudpd *****" && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install build dependencies" && \
  apk add --no-progress --no-cache --virtual=build-deps ${build_dependencies} && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install requirements" && \
   apk add --no-progress --no-cache ${app_dependencies} && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install iCloudPD latest release" && \
   python -m venv /opt/icloudpd_latest && \
   source /opt/icloudpd_latest/bin/activate && \
   pip3 install --upgrade pip && \
   pip3 install --no-cache-dir wheel && \
   pip3 install --no-cache-dir icloudpd && \
   deactivate && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Clean up" && \
   apk del --no-progress --purge build-deps
   

COPY build_version.txt /
COPY --chmod=0755 *.sh /usr/local/bin/
COPY --chmod=-0755 *  /app/
COPY CONFIGURATION.md /opt
# COPY /config/* /config/


# HEALTHCHECK --start-period=10s --interval=1m --timeout=10s CMD /usr/local/bin/healthcheck.sh
  
VOLUME "${config_dir}"

CMD /usr/local/bin/sync-icloud.sh 