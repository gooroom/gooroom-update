#!/usr/bin/python3
import sys
import apt
"""Update packages passed by gooroom-update."""
packages= sys.argv[1:]
try:
    #TODO blacklist package must not be upgrade.
    cache = apt.Cache()
    cache.update()
    cache.open(None)
    for package in packages:
        pkg = cache[package]
        if pkg.is_upgradable:
            pkg.mark_upgrade()

    upgrade_result = cache.commit()
    if upgrade_result:
        print("++ Auto Install finished\n")
    else:
        print ("-- Auto Install failed\n")
except Exception as e:
    print ("-- Exception occured in the auto install thread: " + e +"\n")
