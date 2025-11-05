FROM apache/airflow:2.9.3

USER root
#RUN apt-get update && apt-get install -y openjdk-17-jre dos2unix && rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
  'deb https://deb.debian.org/debian bookworm main' \
  'deb https://deb.debian.org/debian bookworm-updates main' \
  'deb https://security.debian.org/debian-security bookworm-security main' \
  > /etc/apt/sources.list \
  && printf 'Acquire::Retries "5";\nAcquire::ForceIPv4 "true";\n' > /etc/apt/apt.conf.d/99fix \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl gnupg openjdk-17-jre-headless dos2unix \
  && rm -rf /var/lib/apt/lists/*

ENV HOP_HOME=/opt/hop

COPY apache-hop-client-2.14.0/hop/ ${HOP_HOME}/


RUN set -eux; \
  echo "== LIST /opt/hop =="; ls -la ${HOP_HOME}; \
  # nếu script ở thư mục con, tìm và move ra gốc:
  if [ ! -f "${HOP_HOME}/hop-run.sh" ]; then \
    f=$(find ${HOP_HOME} -maxdepth 2 -name hop-run.sh | head -n1 || true); \
    [ -n "$f" ] && mv "$f" "${HOP_HOME}/hop-run.sh"; \
  fi; \
  [ -f "${HOP_HOME}/hop-run.sh" ] || (echo "ERROR: hop-run.sh not found under ${HOP_HOME}"; exit 1); \
  dos2unix ${HOP_HOME}/*.sh || true; \
  chmod +x ${HOP_HOME}/*.sh; \
  install -m 0755 ${HOP_HOME}/hop-run.sh /usr/local/bin/hop-run.sh

USER airflow
ENV PATH="$PATH:/opt/hop"
