#!/usr/bin/env bash
set -eu

export ARCH="${KUBE_ARCH:-`dpkg --print-architecture`}"
KUBE_ARCH=${ARCH}
SNAP_ARCH=${KUBE_ARCH}
if [ "$ARCH" = "ppc64el" ]; then
  KUBE_ARCH="ppc64le"
elif [ "$ARCH" = "armhf" ]; then
  KUBE_ARCH="arm"
fi
export KUBE_ARCH
export CNI_VERSION="${CNI_VERSION:-v0.7.1}"
# RUNC commit matching the containerd release commit
# Tag 1.3.7
export CONTAINERD_COMMIT="${CONTAINERD_COMMIT:-8fba4e9a7d01810a393d5d25a3621dc101981175}"
# Release v1.0.0-rc92
export RUNC_COMMIT="${RUNC_COMMIT:-ff819c7e9184c13b7c2607fe6c30ae19403a7aff}"
# Set this to the kubernetes fork you want to build binaries from
export KUBERNETES_REPOSITORY="${KUBERNETES_REPOSITORY:-github.com/kubernetes/kubernetes}"

export KUBE_TRACK="${KUBE_TRACK:-}"

export KUBE_VERSION="${KUBE_VERSION:-v1.18.9}"
export KUBE_SNAP_BINS="${KUBE_SNAP_BINS:-}"
if [ -e "$KUBE_SNAP_BINS/version" ]; then
  export KUBE_VERSION=`cat $KUBE_SNAP_BINS/version`
else
  # KUBE_SNAP_BINS is not set meaning we will either build the binaries OR fetch them from upstream
  # eitherway the k8s binaries should land at build/kube_bins/$KUBE_VERSION
  if [ -z "$KUBE_VERSION" ]; then
    # KUBE_VERSION is not set we will probably need the one from the upstream repo. If we build from
    # source the KUBE_VERSION should be provided
    if [ -z "$KUBE_TRACK" ]; then
      export KUBE_VERSION="${KUBE_VERSION:-`curl -L https://dl.k8s.io/release/stable.txt`}"
    else
      export KUBE_VERSION="${KUBE_VERSION:-`curl -L https://dl.k8s.io/release/stable-${KUBE_TRACK}.txt`}"
    fi
  fi
fi

export KUBERNETES_TAG="${KUBE_VERSION}"

export KUBE_SNAP_ROOT="$(readlink -f .)"

export EKS_REPO="${EKS_REPO:-https://beta.cdn.model-rocket.aws.dev}"
export EKS_SPEC="${EKS_SPEC:-kubernetes-1-18/kubernetes-1-18-eks-1.yaml}"

echo "Building with:"
echo "KUBE_VERSION=${KUBE_VERSION}"
echo "CNI_VERSION=${CNI_VERSION}"
echo "KUBE_ARCH=${KUBE_ARCH}"
echo "KUBE_SNAP_BINS=${KUBE_SNAP_BINS}"
echo "RUNC_COMMIT=${RUNC_COMMIT}"
echo "CONTAINERD_COMMIT=${CONTAINERD_COMMIT}"
echo "KUBERNETES_REPOSITORY=${KUBERNETES_REPOSITORY}"
echo "KUBERNETES_TAG=${KUBERNETES_TAG}"
echo "EKS_REPO=${EKS_REPO}"
echo "EKS_SPEC=${EKS_SPEC}"
