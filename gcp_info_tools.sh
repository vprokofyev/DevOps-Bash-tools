#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-08-13 19:38:39 +0100 (Thu, 13 Aug 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GCP 'Tools category' resources deployed resources in the current GCP Project

Lists in this order:

    - Cloud Source Repositories
    - Cloud Builds
    - Container Registry Images
    - Deployment Manager
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


# shellcheck disable=SC1090
type is_service_enabled &>/dev/null || . "$srcdir/gcp_service_apis.sh" >/dev/null


# Source Repos
cat <<EOF
# ============================================================================ #
#                            S o u r c e   R e p o s
# ============================================================================ #

EOF

if is_service_enabled sourcerepo.googleapis.com; then
    gcloud source repos list
else
    echo "Source Repos API (sourcerepo.googleapis.com) is not enabled, skipping..."
fi


# Cloud Builds
cat <<EOF


# ============================================================================ #
#                            C l o u d   B u i l d s
# ============================================================================ #

EOF

if is_service_enabled cloudbuild.googleapis.com; then
    gcloud builds list
else
    echo "Cloud Builds API (cloudbuild.googleapis.com) is not enabled, skipping..."
fi


# Container Registry Images
cat <<EOF


# ============================================================================ #
#               C o n t a i n e r   R e g i s t r y   I m a g e s
# ============================================================================ #

EOF

if is_service_enabled containerregistry.googleapis.com; then
    gcloud container images list
else
    echo "Container Registry API (containerregistry.googleapis.com) is not enabled, skipping..."
fi


# Deployment Manager
cat <<EOF


# ============================================================================ #
#                      D e p l o y m e n t   M a n a g e r
# ============================================================================ #

EOF

if is_service_enabled deploymentmanager.googleapis.com; then
    gcloud deployment-manager deployments list
else
    echo "Deployment Manager API (deploymentmanager.googleapis.com) is not enabled, skipping..."
fi