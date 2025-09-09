#!/bin/bash -e

for (( i=1; i<=$#; i++)); do
case ${!i} in
    --api)
    KEY_API=1
    ;;
    --backend)
    KEY_BACKEND=1
    ;;
    --dashboard)
    KEY_DASHBOARD=1
    ;;
    --ci)
    KEY_CI=1
    ;;
    --all)
    KEY_API=1
    KEY_BACKEND=1
    KEY_DASHBOARD=1
    KEY_CI=1
    ;;
    *)
            # unknown option
    echo "Unknown option: ${!i}"
    exit 1
    ;;
esac
done

mkdir -p $HOME/.ssh

if [[ "$KEY_API" == 1 ]]; then
    echo "$GP_API" > $HOME/.ssh/gp_api

    echo "
        Host backend.geopulse
            Hostname github.com
            IdentityFile=$HOME/.ssh/gp_api
            User git
    " >> $HOME/.ssh/config
fi

if [[ "$KEY_BACKEND" == 1 ]]; then
    echo "$GP_BACKEND" > $HOME/.ssh/gp_backend

    echo "
        Host backend.geopulse
            Hostname github.com
            IdentityFile=$HOME/.ssh/gp_backend
            User git
    " >> $HOME/.ssh/config
fi

if [[ "$KEY_DASHBOARD" == 1 ]]; then
    echo "$GP_DASHBOARD" > $HOME/.ssh/gp_dashboard

    echo "
        Host dashboard.geopulse
            Hostname github.com
            IdentityFile=$HOME/.ssh/gp_dashboard
            User git
    " >> $HOME/.ssh/config
fi

if [[ "$KEY_CI" == 1 ]]; then
    echo "$GP_CI" > $HOME/.ssh/gp_ci

    echo "
        Host ci.geopulse
            Hostname github.com
            IdentityFile=$HOME/.ssh/gp_ci
            User git
    " >> $HOME/.ssh/config
fi

chmod 0600 $HOME/.ssh/gp*
