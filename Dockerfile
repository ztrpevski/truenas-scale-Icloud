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

# Create a group and user
RUN addgroup -S apps -u 568 && adduser -m -s /bin/bash -N -u 568 apps && \
    echo "apps ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd 

# Tell docker that all future commands should run as the appuser user
USER apps
  
VOLUME "${config_dir}"

CMD /usr/local/bin/sync-icloud.sh 