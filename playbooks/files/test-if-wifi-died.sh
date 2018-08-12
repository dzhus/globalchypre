#!/bin/bash

dmesg | grep 'wsm_scan failed' && exit 1 || exit 0
