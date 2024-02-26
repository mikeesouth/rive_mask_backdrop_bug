# rive_mask_backdrop_bug

A simple Flutter project to demonstrate an issue with Rive assets with more than one clipping mask.
This issue only affects Impeller rendering in Flutter 3.19 and Impeller is only active on iOS per
default so it only affects iOS in the current state.

I've logged an issue in the rive repo: https://github.com/rive-app/rive-flutter/issues/360

But I'm not sure if the problem is with Rive or with the new Flutter optimization of BackdropFilter
in Flutter 3.19.

This error is also present in Flutter 3.19.1.
