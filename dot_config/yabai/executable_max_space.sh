#! /usr/bin/env bash

yabai -m query --spaces | jq '[.[].index] | max'
