FROM nginx:stable
# デフォルトのNginxの設定ファイルを削除し、作成しておいた設定ファイルをコピー
RUN rm -f /etc/nginx/conf.d/*
COPY ./docker/nginx/revorite.conf /etc/nginx/conf.d/revorite.conf

RUN echo "alias cp='cp -i'" >> /root/.bashrc
RUN echo "alias mv='mv -i'" >> /root/.bashrc
RUN echo "alias rm='rm -i'" >> /root/.bashrc
RUN echo "alias la='ls -al'" >> /root/.bashrc
RUN echo "alias ll='ls -l'" >> /root/.bashrc

# -c以降の設定ファイルを指定して起動 daemon offでフォアグラウンドで起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf