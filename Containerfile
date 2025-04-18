ARG PG_VERSION

FROM ghcr.io/cloudnative-pg/postgresql:${PG_VERSION}-standard-bookworm

ARG PG_VERSION
ARG PG_MAJOR=${PG_VERSION%%.*}

LABEL org.opencontainers.image.description="This container image contains PostgreSQL and useful extensions based on CloudNativePG Postgres ${PG_VERSION}-standard-bookworm."

USER 0

# Install extensions from APT
RUN true && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		git \
		"postgresql-${PG_MAJOR}-wal2json" \
	&& \
	git clone https://github.com/michelp/pgjwt.git && \
		mkdir -p "/usr/share/postgresql/${PG_MAJOR}/extension" && \
		install -c -m 644 pgjwt/pgjwt.control "/usr/share/postgresql/${PG_MAJOR}/extension/" && \
		install -c -m 644 pgjwt/pgjwt--0.1.1.sql pgjwt/pgjwt--0.1.0--0.1.1.sql pgjwt/pgjwt--0.1.1--0.2.0.sql "/usr/share/postgresql/${PG_MAJOR}/extension/" && \
		rm -rf pgjwt && \
	apt-get purge -y git && \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
	rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* && \
	true \

USER 26
