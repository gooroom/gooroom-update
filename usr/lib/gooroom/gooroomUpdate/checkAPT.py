#!/usr/bin/python3

import os
import sys
import apt
import subprocess

#def checkDependencies(changes, cache):
#    foundSomething = False
#    for pkg in changes:
#        for dep in pkg.candidateDependencies:
#            for o in dep.or_dependencies:
#                try:
#                    if cache[o.name].isUpgradable:
#                        pkgFound = False
#                        for pkg2 in changes:
#                            if o.name == pkg2.name:
#                                pkgFound = True
#                        if pkgFound == False:
#                            newPkg = cache[o.name]
#                            changes.append(newPkg)
#                            foundSomething = True
#                except Exception as detail:
#                    pass # don't know why we get these..
#    if (foundSomething):
#        changes = checkDependencies(changes, cache)
#    return changes

try:
    cache = apt.Cache()

    if os.getuid() == 0 :
        use_synaptic = False
        if (len(sys.argv) > 1):
            if sys.argv[1] == "--use-synaptic":
                use_synaptic = True

        if use_synaptic:
            window_id = int(sys.argv[2])
            from subprocess import Popen, PIPE
            cmd = ["sudo", "/usr/sbin/synaptic", "--hide-main-window", "--update-at-startup", "--non-interactive", "--parent-window-id", "%d" % window_id]
            #cmd.append("--progress-str")
            #cmd.append("\"" + _("Please wait, this can take some time") + "\"")
            comnd = Popen(' '.join(cmd), shell=True)
            returnCode = comnd.wait()
            #sts = os.waitpid(comnd.pid, 0)
        else:
            cache.update()

    dist_upgrade = True

    # Reopen the cache to reflect any updates
    cache.open(None)
    cache.upgrade(dist_upgrade)
    changes = cache.get_changes()

    # Add dependencies
    #changes = checkDependencies(changes, cache)

    for pkg in changes:
        if (pkg.is_installed and pkg.marked_upgrade):
            package = pkg.name
            newVersion = pkg.candidate.version
            oldVersion = pkg.installed.version
            size = pkg.candidate.size
            sourcePackage = pkg.candidate.source_name
            short_description = pkg.candidate.raw_description
            description = pkg.candidate.description
            if (newVersion != oldVersion):
                update_type = "package"
                update_origin = "gooroom"
                for origin in pkg.candidate.origins:
                    if origin.origin == "Debian":
                        update_origin = "debian"
                    if origin.origin == "Debian" and '-Security' in origin.label:
                        update_type = "security"
                        break
                    if origin.origin == "Gooroom" or origin.origin == 'gooroom':
                        update_type = "gooroom"

                resultString = "UPDATE###%s###%s###%s###%s###%s###%s###%s###%s###%s---EOL---" % (package, newVersion, oldVersion, size, sourcePackage, update_type, update_origin, short_description, description)
                print (resultString.encode('ascii', 'xmlcharrefreplace'))

except Exception as detail:
    print ("CHECK_APT_ERROR---EOL---")
    print (detail)
    sys.exit(1)
