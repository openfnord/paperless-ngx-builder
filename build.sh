#!/usr/bin/env bash

set -eux

function build_qpdf()
{
	local -r image_tag="qpdf:${1}"
	docker build --tag "${image_tag}" --build-arg QPDF_VERSION="${1}" --file qpdf.dockerfile --progress plain .
	image_id=$(docker create "${image_tag}")
	mkdir -v -p outputs
	docker cp "${image_id}":/usr/src/qpdf/ outputs/
}

function build_ghostscript()
{
	local -r image_tag="ghostscript:${1}"
	docker build --tag "${image_tag}" --build-arg GS_VERSION="${1}" --file ghostscript.dockerfile --progress plain .
	image_id=$(docker create "${image_tag}")
	mkdir -v -p outputs
	docker cp "${image_id}":/usr/src/ghostscript/ outputs/
}

function build_jbig2enc()
{
	local -r image_tag="jbig2enc:${1}"
	docker build --tag "${image_tag}" --build-arg JBIG2ENC_VERSION="${1}" --file jbig2enc.dockerfile --progress plain .
	image_id=$(docker create "${image_tag}")
	mkdir -v -p outputs
	docker cp "${image_id}":/usr/src/jbig2enc/ outputs/
}

function build_psycopg()
{
	local -r image_tag="psycopg:${1}"
	docker build --tag "${image_tag}" --build-arg PSYCOPG_VERSION="${1}" --file psycopg.dockerfile --progress plain .
	image_id=$(docker create "${image_tag}")
	mkdir -v -p outputs/psycopg
	docker cp "${image_id}":/usr/src/psycopg/ outputs/
}

subcommand=$1

case "${subcommand}" in

	qpdf)
		build_qpdf "${2:-11.9.1}"
		;;

	ghostscript)
		build_ghostscript "${2:-10.03.1}"
		;;

	jbig2enc)
		build_jbig2enc "${2:-0.29}"
		;;

	psycopg)
		build_psycopg "${2:-3.1.19}"
		;;

	*)
		echo "${1} is not a valid argument"
		exit 1
		;;
esac
