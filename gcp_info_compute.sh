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
Lists GCP Compute resources deployed in the current GCP Project

Lists in this order:

    - GCE Virtual Machines
    - App Engine instances
    - Cloud Functions
    - GKE Clusters
    - Kubernetes, for every GKE cluster:
      - cluster-info
      - master component statuses
      - nodes
      - namespaces
      - deployments, replicasets, replication controllers, statefulsets, daemonsets, horizontal pod autoscalers
      - storage classes, persistent volumes, persistent volume claims
      - service accounts, resource quotas, network policies, pod security policies
      - pods  # might be too volumous if you have high replica counts, so done last, comment if you're sure nobody has deployed pods outside deployments
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


# shellcheck disable=SC1090
type is_service_enabled &>/dev/null || . "$srcdir/gcp_service_apis.sh" >/dev/null


# GCE Virtual Machines
cat <<EOF
# ============================================================================ #
#                        V i r t u a l   M a c h i n e s
# ============================================================================ #

EOF

if is_service_enabled compute.googleapis.com; then
    #gcloud compute machine-types list

    gcloud compute instances list --sort-by=ZONE
else
    echo "GCE API (compute.googleapis.com) is not enabled, skipping..."
fi


# App instances
cat <<EOF


# ============================================================================ #
#                    A p p   E n g i n e   i n s t a n c e s
# ============================================================================ #

EOF

# works even when all of these are disabled:
#
# DISABLED  accessapproval.googleapis.com                         Access Approval API
# DISABLED  appengine.googleapis.com                              App Engine Admin API
# DISABLED  appengineflex.googleapis.com                          Google App Engine Flexible Environment
#
#if is_service_enabled appengine.googleapis.com; then
    gcloud app instances list
#else
#    echo "GAE API (appengine.googleapis.com) is not enabled, skipping..."
#fi


# Cloud Functions
cat <<EOF


# ============================================================================ #
#                         C l o u d   F u n c t i o n s
# ============================================================================ #

EOF

if is_service_enabled cloudfunctions.googleapis.com; then
    gcloud functions list
else
    echo "Cloud Functions API (cloudfunctions.googleapis.com) is not enabled, skipping..."
fi


# Cloud Run
cat <<EOF


# ============================================================================ #
#                               C l o u d   R u n
# ============================================================================ #

EOF

# confirm this one
if is_service_enabled run.googleapis.com; then
    gcloud run services list
else
    echo "Cloud RUN API (run.googleapis.com) is not enabled, skipping..."
fi


# ============================================================================ #
echo
echo
. "$srcdir/gcp_info_gke.sh"